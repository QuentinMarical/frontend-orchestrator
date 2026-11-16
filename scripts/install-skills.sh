#!/usr/bin/env bash
# Installe les skills appelés par frontend-orchestrator.
# Chaque commande est indépendante : un échec n'arrête pas le reste.
# Vérifiez les commandes dans le README avant de lancer.
set -u

run() {
  echo ""
  echo "▶ $*"
  "$@" || echo "  ⚠ échec (on continue) : $*"
}

command -v claude >/dev/null 2>&1 || echo "ℹ Claude Code introuvable : les commandes 'claude plugin' échoueront."
command -v npx    >/dev/null 2>&1 || echo "ℹ npx introuvable : installez Node.js pour les commandes 'npx skills'."

run claude plugin install frontend-design@claude-plugins-official
run claude plugin install vercel@claude-plugins-official

run claude plugin marketplace add nextlevelbuilder/ui-ux-pro-max-skill
run claude plugin install ui-ux-pro-max@ui-ux-pro-max-skill

run npx -y skills add bencium/bencium-marketplace --agent claude-code

run claude plugin marketplace add accesslint/skills
run claude plugin install accesslint@accesslint

run npx -y skills add mrgoonie/claudekit-skills --skill ui-styling --agent claude-code

echo ""
echo "Terminé. Relancez votre agent pour charger les skills."
