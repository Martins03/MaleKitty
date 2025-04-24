$objetos = Get-Content "git-objects.txt"
$resultado = @()

foreach ($line in $objetos) {
    $parts = $line -split " "
    if ($parts.Length -lt 2) { continue }

    $hash = $parts[0]
    $file = $parts[1..($parts.Length - 1)] -join " "
    $size = git cat-file -s $hash 2>$null

    if ($size -gt 1000000) {  # só ficheiros maiores que 1MB
        $resultado += [PSCustomObject]@{
            SizeMB = [Math]::Round($size / 1MB, 2)
            File   = $file
        }
    }
}

$resultado | Sort-Object SizeMB -Descending | Select-Object -First 20 | Format-Table -AutoSize
