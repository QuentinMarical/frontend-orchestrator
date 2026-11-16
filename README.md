# frontend-orchestrator

Un seul skill qui choisit, ordonne et appelle vos autres skills d'interface : design, accessibilité, Vercel.

Il ne copie le contenu d'aucun skill. Il lit la demande, retient un mode (`build`, `audit`, `fix`, `ship`, `full`), puis charge uniquement les skills nécessaires, dans le bon ordre. Moins de contexte consommé, moins d'hésitation de l'agent entre skills qui se recoupent.

## Les modes

| Mode | Quand | Chaîne |
|---|---|---|
| `build` | Créer une page, un composant, une app | direction créative → `ui-ux-pro-max` → stack → `ui-typography` → contrôle a11y |
| `audit` | Évaluer une UI existante | `design-audit` → `ui-ux-pro-max` → `accessibility-scan` / `accessibility-audit` |
| `fix` | Corriger l'accessibilité | `accessibility-scan` → `accessibility-fix` → `accessibility-diff` |
| `ship` | Mettre en ligne | `vercel:verification` → `vercel:deploy` |
| `full` | De zéro à la prod | `build` → `fix` → `ship` |

Règles clés : une seule direction créative par tâche, la typographie passe en dernier, l'accessibilité valide après le code, aucune action sortante sans accord. Tout est dans [`SKILL.md`](skills/frontend-orchestrator/SKILL.md). Les skills absents sont simplement sautés.

## Installation

### 1. L'orchestrateur

```bash
npx skills add QuentinMarical/frontend-orchestrator
```

Ou à la main : copiez `skills/frontend-orchestrator/` dans le dossier de skills de votre agent (voir le tableau de compatibilité).

### 2. Les skills qu'il appelle

Les scripts `scripts/install-skills.sh` (macOS/Linux/Git Bash) et `scripts/install-skills.ps1` (Windows) lancent les commandes ci-dessous l'une après l'autre et continuent si l'une échoue.

```bash
# Direction créative et plugins (Claude Code)
claude plugin install frontend-design@claude-plugins-official
claude plugin install vercel@claude-plugins-official

# Intelligence de design (nécessite Python 3)
claude plugin marketplace add nextlevelbuilder/ui-ux-pro-max-skill
claude plugin install ui-ux-pro-max@ui-ux-pro-max-skill

# Skills bencium (contrôlé, impact, innovant, AEO)
npx -y skills add bencium/bencium-marketplace --agent claude-code

# Accessibilité AccessLint
claude plugin marketplace add accesslint/skills
claude plugin install accesslint@accesslint

# Implémentation (shadcn/ui + Tailwind)
npx -y skills add mrgoonie/claudekit-skills --skill ui-styling --agent claude-code
```

> **À vérifier avant de lancer.** Ces commandes viennent de la documentation publique et de répertoires tiers, pas d'un test sur votre machine. Les noms de marketplace changent parfois (par exemple `accesslint@accesslint` ou `accesslint@accesslint-skills`). En cas d'erreur, ouvrez le dépôt du skill concerné et reprenez sa commande officielle. Le skill `ui-typography` n'a pas de source vérifiée : l'orchestrateur fonctionne sans.

## Compatibilité avec les applis d'IA

L'orchestrateur est un dossier `SKILL.md` au format ouvert [Agent Skills](https://agentskills.io). Il fonctionne donc sur les agents qui chargent ce format. D'après les sources publiques consultées (blogs et documentation, pas de test de notre côté), c'est le cas de :

| Appli | Dossier de skills (projet) | Note |
|---|---|---|
| Claude Code | `.claude/skills/` | Référence. Appel des autres skills via l'outil `Skill`, préfixes `plugin:skill` pris en charge. |
| OpenAI Codex CLI | `.agents/skills/` | Appelez les skills par leur nom simple. |
| Gemini CLI | selon version | Format `SKILL.md` annoncé comme pris en charge. |
| Cursor | selon version | Idem. |
| GitHub Copilot / VS Code | selon version | Idem. |
| JetBrains Junie, Amp, Roo Code, Goose, Windsurf, Continue | selon version | Cités par des sources tierces. |

Le CLI `npx skills add <dépôt> -a <agent>` sait installer dans le bon dossier pour de nombreux agents (plusieurs dizaines selon sa documentation) ; `-g` installe pour l'utilisateur.

Limites à connaître :
- Les champs de front matter propres à Claude Code (`allowed-tools`, `argument-hint`) sont ignorés ailleurs. L'orchestrateur n'en dépend pas.
- Les skills **appelés** doivent aussi être installés sur l'agent choisi. Les plugins Claude Code (`/plugin install`) ne s'appliquent qu'à Claude Code.
- L'accessibilité en direct demande Chrome et le serveur MCP AccessLint ; sans eux, la revue reste statique.
- Pas de gestion native de ce format dans Claude.ai web sans l'activer côté compte : vérifiez la documentation de votre offre.

## Exemple

[`docs/index.html`](docs/index.html) est le site GitHub Pages du projet, une landing page produite avec la chaîne `build` : `frontend-design` → `ui-ux-pro-max` → `ui-typography`. Ouvrez le fichier dans un navigateur.

## Licence

MIT. Voir [LICENSE](LICENSE).
