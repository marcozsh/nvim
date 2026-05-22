# Neovim Configuration Setup for Linux

Una configuración completa de Neovim con soporte para LSP, Treesitter, GitHub Copilot, y más.

## Requisitos Previos

> [!IMPORTANT]
> - **Node.js** (requerido para LSP servers y herramientas)
> - **Git** (para clonar el repositorio y gestionar plugins)
> - **GCC/Build Essentials** (requerido para compilar plugins nativos y Treesitter)
> - **Go** (requerido para desarrollo en Go y golangci-lint)

## Instalación Paso a Paso

### 1. Instalar Dependencias del Sistema

#### Ubuntu/Debian
```bash
sudo apt update
sudo apt install -y neovim git gcc make ripgrep curl
```

#### Fedora/RHEL
```bash
sudo dnf install -y neovim git gcc make ripgrep curl
```

#### Arch Linux
```bash
sudo pacman -S neovim git gcc make ripgrep curl
```

Verifica la instalación de Neovim:
```bash
nvim --version
```

### 2. Instalar Node.js y Herramientas Globales

#### Usando NodeSource (Ubuntu/Debian)
```bash
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs
```

#### Usando DNF (Fedora)
```bash
sudo dnf install -y nodejs
```

#### Usando Pacman (Arch)
```bash
sudo pacman -S nodejs npm
```

Instala las herramientas necesarias globalmente:
```bash
npm install -g prettier
npm install -g live-server
```

> [!NOTE]
> Los LSP servers (pyright, typescript-language-server, tailwindcss-language-server, etc.) se instalarán automáticamente mediante **Mason** al abrir Neovim por primera vez.

### 2.1. Configurar Go (Opcional)

Si vas a desarrollar en Go, necesitas instalar Go y el linter:

#### Instalar Go
```bash
# Ubuntu/Debian/Fedora
sudo apt install -y golang-go  # o sudo dnf install -y golang

# Arch Linux
sudo pacman -S go
```

Verifica la instalación:
```bash
go version
```

#### Instalar golangci-lint (Linter para Go)
```bash
go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
```

> [!IMPORTANT]
> Asegúrate de que `$HOME/go/bin` esté en tu PATH. Si no es así, agrégalo a tu `~/.bashrc` o `~/.zshrc`:
> ```bash
> export PATH="$HOME/go/bin:$PATH"
> ```

### 3. Clonar la Configuración

Navega al directorio de configuración de Neovim y clona el repositorio:

```bash
# Crear el directorio si no existe
mkdir -p ~/.config/nvim

# Navegar al directorio
cd ~/.config/nvim

# Clonar el repositorio (reemplaza con tu URL de repo)
git clone https://github.com/marcozsh/init.vim.git .
```

### 4. Primera Ejecución de Neovim

Abre Neovim para que se instalen automáticamente los plugins:

```bash
nvim
```

**Lazy.nvim** se instalará automáticamente y comenzará a descargar todos los plugins. Este proceso puede tomar varios minutos.

> [!TIP]
> Si ves errores durante la primera ejecución, es normal. Espera a que todos los plugins se descarguen y cierra Neovim con `:q`, luego ábrelo nuevamente.

### 5. Instalar Parsers de Treesitter

Una vez que Neovim esté abierto y los plugins instalados, instala los parsers de Treesitter para los lenguajes que uses:

```vim
:TSInstall lua python javascript typescript html css go
```

O para instalar un lenguaje específico:
```vim
:TSInstall <lenguaje>
```

### 6. Verificar Instalación de LSP Servers

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
- gopls
- golangci-lint

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
```bash
# Ubuntu/Debian
sudo apt install ripgrep

# Fedora
sudo dnf install ripgrep

# Arch
sudo pacman -S ripgrep
```

### Treesitter no compila
Verifica que GCC y Make estén instalados:
```bash
gcc --version
make --version
```

Si no están instalados:
```bash
# Ubuntu/Debian
sudo apt install -y build-essential

# Fedora
sudo dnf groupinstall "Development Tools"

# Arch
sudo pacman -S base-devel
```

### LSP no funciona
1. Abre Mason: `:Mason`
2. Verifica que los servidores estén instalados
3. Para reinstalar: selecciona el servidor y presiona `X` para desinstalar, luego `i` para instalar

### golangci-lint no funciona
Si ves el error "Linter command exited with code: 1" al guardar archivos `.go`:

1. Verifica que golangci-lint esté instalado:
```bash
golangci-lint --version
```

2. Si no está instalado:
```bash
go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
```

3. Asegúrate de que el directorio de Go bin esté en tu PATH:
```bash
export PATH="$HOME/go/bin:$PATH"
```

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
```bash
cd ~/.config/nvim
git pull
```

---

¡Disfruta de Neovim! 🚀
