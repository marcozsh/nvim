# Neovim Configuration Setup for Windows

Una configuración completa de Neovim con soporte para LSP, Treesitter, GitHub Copilot, y más.

## Requisitos Previos

> [!IMPORTANT]
> - **Node.js** (requerido para LSP servers y herramientas)
> - **Git** (para clonar el repositorio y gestionar plugins)
> - **PowerShell** (incluido en Windows)
> - **Windows 10/11**

## Instalación Paso a Paso

### 1. Instalar Scoop (Gestor de Paquetes)

Abre PowerShell como administrador y ejecuta:

```PowerShell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
```

### 2. Instalar Neovim

```PowerShell
scoop install main/neovim
```

Verifica la instalación:
```PowerShell
nvim --version
```

### 3. Instalar Herramientas Esenciales

#### Git (si no lo tienes instalado)
```PowerShell
scoop install git
```

#### GCC (Requerido para nvim-treesitter)
```PowerShell
scoop install gcc
```

#### Ripgrep (Para búsqueda con Telescope)
```PowerShell
scoop install ripgrep
```

#### LazyGit (Para gestión de Git en Neovim)
```PowerShell
scoop bucket add extras
scoop install lazygit
```

### 4. Instalar Node.js y Herramientas Globales

Si no tienes Node.js instalado:
```PowerShell
scoop install nodejs
```

Instala las herramientas necesarias globalmente:
```PowerShell
npm install -g prettier
npm install -g live-server
```

> [!NOTE]
> Los LSP servers (pyright, typescript-language-server, tailwindcss-language-server, etc.) se instalarán automáticamente mediante **Mason** al abrir Neovim por primera vez.

### 5. Clonar la Configuración

Navega al directorio de configuración de Neovim y clona el repositorio:

```PowerShell
# Crear el directorio si no existe
New-Item -ItemType Directory -Force -Path "$env:LOCALAPPDATA\nvim"

# Navegar al directorio
Set-Location "$env:LOCALAPPDATA\nvim"

# Clonar el repositorio (reemplaza con tu URL de repo)
git clone https://github.com/marcozsh/init.vim.git .
```

### 6. Primera Ejecución de Neovim

Abre Neovim para que se instalen automáticamente los plugins:

```PowerShell
nvim
```

**Lazy.nvim** se instalará automáticamente y comenzará a descargar todos los plugins. Este proceso puede tomar varios minutos.

> [!TIP]
> Si ves errores durante la primera ejecución, es normal. Espera a que todos los plugins se descarguen y cierra Neovim con `:q`, luego ábrelo nuevamente.

### 7. Instalar Parsers de Treesitter

Una vez que Neovim esté abierto y los plugins instalados, instala los parsers de Treesitter para los lenguajes que uses:

```vim
:TSInstall lua python javascript typescript html css
```

O para instalar un lenguaje específico:
```vim
:TSInstall <lenguaje>
```

### 8. Verificar Instalación de LSP Servers

Los LSP servers se instalan automáticamente mediante **mason-tool-installer**. Para verificar:

```vim
:Mason
```

Deberías ver instalados:
- lua-language-server
- pyright
- typescript-language-server
- tailwindcss-language-server
- rust-analyzer
- angular-language-server
- gleam
- ocaml-lsp

Si alguno falta, puedes instalarlo manualmente desde la UI de Mason (presiona `i` sobre el paquete).

## Configuración de GitHub Copilot (Opcional)

Si usas GitHub Copilot, necesitas autenticarte la primera vez:

```vim
:Copilot setup
```

Sigue las instrucciones en pantalla para conectar tu cuenta de GitHub.

## Estructura de la Configuración

```
nvim/
├── init.lua                    # Punto de entrada principal
├── lua/
│   └── marcozsh/
│       ├── init.lua           # Carga módulos
│       ├── lazy.lua           # Configuración de plugins con lazy.nvim
│       ├── set.lua            # Configuraciones de Neovim
│       └── remap.lua          # Keymaps personalizados
└── after/
    └── plugin/
        └── airline.lua        # Configuración de vim-airline
```

## Atajos de Teclado Principales

### General
- `<Space>` - Leader key

### Telescope (Búsqueda)
- `<leader>ff` o `ff` - Buscar archivos
- `<leader>fg` o `fg` - Buscar en contenido (live grep)
- `<leader>fb` - Buscar buffers
- `<leader>fh` - Buscar ayuda

### Explorador de Archivos (nvim-tree)
- Se abre automáticamente al iniciar Neovim sin archivos

### LSP
- `K` - Mostrar documentación (hover)
- `gd` - Ir a definición
- `gD` - Ir a declaración
- `gi` - Ir a implementación
- `gr` - Mostrar referencias
- `<F2>` - Renombrar símbolo
- `<F3>` - Formatear código
- `<F4>` - Acciones de código

### Git (LazyGit)
- `:LazyGit` - Abrir LazyGit

### Trouble (Diagnósticos)
- `<leader>xx` - Toggle diagnósticos
- `<leader>xX` - Diagnósticos del buffer actual

## Solución de Problemas

### Live Grep no funciona
Asegúrate de tener ripgrep instalado:
```PowerShell
scoop install ripgrep
```

### Treesitter no compila
Verifica que GCC esté instalado:
```PowerShell
gcc --version
```

Si no está instalado:
```PowerShell
scoop install gcc
```

### LSP no funciona
1. Abre Mason: `:Mason`
2. Verifica que los servidores estén instalados
3. Para reinstalar: selecciona el servidor y presiona `X` para desinstalar, luego `i` para instalar

### Plugins no se cargan
Ejecuta en Neovim:
```vim
:Lazy sync
```

## Actualizaciones

Para actualizar los plugins:
```vim
:Lazy update
```

Para actualizar la configuración:
```PowerShell
cd $env:LOCALAPPDATA\nvim
git pull
```

---

¡Disfruta de Neovim! 🚀
