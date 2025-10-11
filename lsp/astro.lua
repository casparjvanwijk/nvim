---@brief
---
--- https://github.com/withastro/language-tools/tree/main/packages/language-server
---
--- `astro-ls` can be installed via `npm`:
--- ```sh
--- npm install -g @astrojs/language-server
--- ```

---@type vim.lsp.Config
return {
    cmd = { 'astro-ls', '--stdio' },
    filetypes = { 'astro' },
    root_markers = { 'package.json', 'tsconfig.json', 'jsconfig.json', '.git' },
    init_options = {
        typescript = {},
    },
    before_init = function(_, config)
        if config.init_options
            and config.init_options.typescript
            and not config.init_options.typescript.tsdk then
            -- point to TypeScript bundled in node_modules if available
            local tsdk = vim.fs.find("node_modules/typescript/lib", {
                upward = true,
                path = config.root_dir,
            })[1]
            config.init_options.typescript.tsdk = tsdk
        end
    end,
}
