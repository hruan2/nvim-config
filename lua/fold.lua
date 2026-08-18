local M = {}

function M.foldtext()
    local line = vim.fn.getline(vim.v.foldstart)
    local line_count = vim.v.foldend - vim.v.foldstart + 1
    local line_text = vim.fn.substitute(line, "\t", " ", "g")
    return string.format("%s (%d lines)", line_text, line_count)
end

--- Resolve the fold expression for `buf` and write it to every window showing it.
--- LSP folding is preferred, but only once the server has actually returned ranges
--- (see M.probe); treesitter is the fallback. Buffers with neither are left alone so
--- this stays safe to call from BufWinEnter, which fires for help/quickfix/scratch too.
---@param buf integer buffer handle
---@param opts? { reset_foldlevel?: boolean } reset_foldlevel opens all folds; pass it
---       only on first load, so a session-restored fold level survives a re-apply.
function M.apply(buf, opts)
    if not vim.api.nvim_buf_is_valid(buf) then
        return
    end

    local expr
    if vim.b[buf].lsp_folding_ready then
        expr = "v:lua.vim.lsp.foldexpr()"
    elseif vim.treesitter.highlighter.active[buf] then
        -- Only claim folding for languages that ship a folds query. vimdoc, gitcommit and
        -- asm have none, and overwriting foldexpr there trades the ftplugin's own folding
        -- (:help section folds, for one) for no folds at all.
        local ok, parser = pcall(vim.treesitter.get_parser, buf, nil, { error = false })
        if not (ok and parser and vim.treesitter.query.get(parser:lang(), 'folds')) then
            return
        end
        expr = "v:lua.vim.treesitter.foldexpr()"
    else
        return -- no parser, no ranges: leave this buffer's folding alone
    end

    for _, win in ipairs(vim.fn.win_findbuf(buf)) do
        if not vim.wo[win].diff then -- never fight foldmethod=diff
            -- vim.wo[win][0] scopes these to (win, buf) so they are remembered
            -- per buffer instead of leaking onto the next buffer in this window.
            local wo = vim.wo[win][0]
            wo.foldmethod = 'expr'
            wo.foldexpr = expr
            if opts and opts.reset_foldlevel and wo.foldlevel < 99 then
                wo.foldlevel = 99
            end
        end
    end
end

--- Ask the server for folding ranges, and switch the buffer over to LSP folding only
--- if it actually returns some. Waiting for the reply is what keeps this deterministic:
--- it always lands after the FileType handler, whether the client was warm or cold, and
--- clangd cannot answer until it has built an AST -- adopting LSP folding at attach time
--- leaves the buffer with no folds at all until then.
---@param client vim.lsp.Client
---@param buf integer buffer handle
function M.probe(client, buf)
    client:request('textDocument/foldingRange',
        { textDocument = vim.lsp.util.make_text_document_params(buf) },
        function(err, result)
            if err or not result or #result == 0 then
                return
            end
            if not vim.api.nvim_buf_is_valid(buf) then
                return
            end
            vim.b[buf].lsp_folding_ready = true
            M.apply(buf)
        end, buf)
end

return M
