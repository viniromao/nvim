local mason_registry = require('mason-registry')

local function setup_jdtls()
  local jdtls_pkg = mason_registry.get_package('jdtls')

  if not jdtls_pkg:is_installed() then
    return
  end

  local jdtls_path = jdtls_pkg:get_install_path()
  local lombok_path = jdtls_path .. '/lombok.jar'

  local system = vim.fn.has('mac') == 1 and 'mac' or 'linux'
  local config_path = jdtls_path .. '/config_' .. system

  local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
  local workspace_dir = vim.fn.stdpath('data') .. '/jdtls-workspace/' .. project_name

  local config = {
    cmd = {
      'java',
      '-Declipse.application=org.eclipse.jdt.ls.core.id1',
      '-Dosgi.bundles.defaultStartLevel=4',
      '-Declipse.product=org.eclipse.jdt.ls.core.product',
      '-Dlog.protocol=true',
      '-Dlog.level=ALL',
      '-Xmx1g',
      '--add-modules=ALL-SYSTEM',
      '--add-opens', 'java.base/java.util=ALL-UNNAMED',
      '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
      '-javaagent:' .. lombok_path,
      '-jar', vim.fn.glob(jdtls_path .. '/plugins/org.eclipse.equinox.launcher_*.jar'),
      '-configuration', config_path,
      '-data', workspace_dir,
    },

    root_dir = require('jdtls.setup').find_root({ '.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle' }),

    settings = {
      java = {
        signatureHelp = { enabled = true },
        import = { enabled = true },
        rename = { enabled = true },
        references = {
          includeDecompiled = true,
        },
        format = {
          enabled = true,
        },
        saveActions = {
          organizeImports = true,
        },
        completion = {
          favoriteStaticMembers = {
            'org.junit.jupiter.api.Assertions.*',
            'org.mockito.Mockito.*',
            'org.mockito.ArgumentMatchers.*',
            'org.assertj.core.api.Assertions.*',
          },
          importOrder = {
            'java',
            'javax',
            'com',
            'org',
          },
        },
        sources = {
          organizeImports = {
            starThreshold = 9999,
            staticStarThreshold = 9999,
          },
        },
        codeGeneration = {
          toString = {
            template = '${object.className}{${member.name()}=${member.value}, ${otherMembers}}',
          },
          useBlocks = true,
        },
        configuration = {
          updateBuildConfiguration = 'interactive',
        },
      },
    },

    capabilities = require('cmp_nvim_lsp').default_capabilities(),
  }

  require('jdtls').start_or_attach(config)
end

local ok, _ = pcall(function()
  if mason_registry.is_installed('jdtls') then
    setup_jdtls()
  else
    mason_registry.refresh(function()
      vim.schedule(setup_jdtls)
    end)
  end
end)
