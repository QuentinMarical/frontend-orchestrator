# Installe les skills appeles par frontend-orchestrator (Windows PowerShell).
# Chaque commande est independante : un echec n'arrete pas le reste.
# Verifiez les commandes dans le README avant de lancer.

function Run {
  param([string]$Exe, [string[]]$Args)
  Write-Host ""
  Write-Host ">> $Exe $($Args -join ' ')"
  & $Exe @Args
  if ($LASTEXITCODE -ne 0) { Write-Host "   echec (on continue) : $Exe $($Args -join ' ')" -ForegroundColor Yellow }
}

if (-not (Get-Command claude -ErrorAction SilentlyContinue)) { Write-Host "Claude Code introuvable : les commandes 'claude plugin' echoueront." }
if (-not (Get-Command npx -ErrorAction SilentlyContinue))    { Write-Host "npx introuvable : installez Node.js pour les commandes 'npx skills'." }

Run claude @('plugin','install','frontend-design@claude-plugins-official')
Run claude @('plugin','install','vercel@claude-plugins-official')

Run claude @('plugin','marketplace','add','nextlevelbuilder/ui-ux-pro-max-skill')
Run claude @('plugin','install','ui-ux-pro-max@ui-ux-pro-max-skill')

Run npx @('-y','skills','add','bencium/bencium-marketplace','--agent','claude-code')

Run claude @('plugin','marketplace','add','accesslint/skills')
Run claude @('plugin','install','accesslint@accesslint')

Run npx @('-y','skills','add','mrgoonie/claudekit-skills','--skill','ui-styling','--agent','claude-code')

Write-Host ""
Write-Host "Termine. Relancez votre agent pour charger les skills."
