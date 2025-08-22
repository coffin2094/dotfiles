-- Send all buffer diagnostics to quickfix list
vim.keymap.set("n", "<C-q>", function()
    -- Get diagnostics for current buffer
    local bufnr = 0  -- current buffer
    local diagnostics = vim.diagnostic.get(bufnr)

    -- Convert diagnostics to quickfix format
    local items = {}
    for _, d in ipairs(diagnostics) do
        table.insert(items, {
            bufnr = d.bufnr,
            lnum = d.lnum + 1,  -- quickfix is 1-indexed
            col = d.col + 1,
            text = d.message,
            type = string.upper(d.severity == vim.diagnostic.severity.ERROR and "E" or
                                d.severity == vim.diagnostic.severity.WARN and "W" or
                                d.severity == vim.diagnostic.severity.INFO and "I" or
                                "H"),
        })
    end

    -- Set quickfix list and open it
    vim.fn.setqflist({}, " ", { title = "Buffer Diagnostics", items = items })
    vim.cmd("copen")
end, { desc = "Send all buffer diagnostics to Quickfix" })

-- Auto-update quickfix list whenever diagnostics change in the current buffer
vim.api.nvim_create_autocmd({"DiagnosticChanged"}, {
    callback = function()
        local bufnr = 0
        local diagnostics = vim.diagnostic.get(bufnr)
        local items = {}
        for _, d in ipairs(diagnostics) do
            table.insert(items, {
                bufnr = d.bufnr,
                lnum = d.lnum + 1,
                col = d.col + 1,
                text = d.message,
                type = string.upper(d.severity == vim.diagnostic.severity.ERROR and "E" or
                                    d.severity == vim.diagnostic.severity.WARN and "W" or
                                    d.severity == vim.diagnostic.severity.INFO and "I" or
                                    "H"),
            })
        end
        vim.fn.setqflist({}, " ", { title = "Buffer Diagnostics", items = items })
    end,
})


