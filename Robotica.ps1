# Archivo: iniciar.ps1
$envFolder = "src/python"
$envName = "venv"
$envPath = "$envFolder\$envName"
$requirements = "$envFolder\requirements.txt"
$kernelName = "robotica"
$displayName = "Python (Robótica)"

if (-Not (Test-Path $envPath)) {
    Write-Host "Creando entorno virtual..."
    py -m venv $envPath
}

Write-Host "Activando entorno virtual..."
& "$envPath\Scripts\Activate.ps1"

Write-Host "Instalando dependencias..."
py -m pip install -r $requirements

# Registrar el kernel si no existe
$kernelPath = "$env:APPDATA\jupyter\kernels\$kernelName"
if (-Not (Test-Path $kernelPath)) {
    Write-Host "Registrando kernel de Jupyter..."
    py -m ipykernel install --user --name $kernelName --display-name $displayName
} else {
    Write-Host "Kernel ya registrado: $displayName"
}

Write-Host "Entorno virtual activado y dependencias instaladas."
