---
name: frontend-orchestrator
description: "Chef d'orchestre des skills UI/frontend (frontend-design, bencium-*, ui-ux-pro-max, ui-styling, ui-typography, design-*, accessibility-* AccessLint, vercel:*). À utiliser dès qu'une tâche touche à une interface web : créer une page/composant/app, design/redesign, audit UI/UX, design system, typographie, accessibilité (a11y/WCAG), déploiement Vercel, Next.js/React/shadcn. Choisit les bons skills, dans le bon ordre, et les appelle via l'outil Skill. Triggers: frontend, UI, UX, interface, landing page, composant, dashboard, design, a11y, accessibilité, Vercel, Next.js, shadcn, Tailwind."
argument-hint: "[tâche UI] [--mode build|audit|fix|ship|full] [url|chemin]"
---

# Frontend Orchestrator

Routeur léger : **ne duplique aucun contenu**, charge seulement les skills nécessaires (économie de tokens) via l'outil `Skill`. Ne jamais tous les charger : 1 skill de direction + 0-2 spécialistes + 1 étape de contrôle suffit.

## Procédure

1. Identifier le **mode** (voir tableau). Si ambigu, choisir `build` pour une création, `audit` pour du code/UI existant.
2. Appeler les skills de la chaîne du mode, **dans l'ordre**, un par un (`Skill` avec le nom exact).
3. Appliquer les règles de conflit ci-dessous.
4. Terminer par le contrôle qualité (a11y) si du code UI a été produit ou modifié.
5. Résumer en 5 lignes max : skills utilisés, livrables, points restants.

## Modes et chaînes

| Mode | Quand | Chaîne (ordre) |
|---|---|---|
| `build` | Créer page / composant / app | direction → `ui-ux-pro-max` → stack (`ui-styling` / `vercel:nextjs` / `vercel:shadcn`) → `ui-typography` → contrôle |
| `audit` | Évaluer une UI existante | `design-audit` → `ui-ux-pro-max` (revue) → `accessibility-scan` ou `accessibility-audit` |
| `fix` | Corriger a11y / régressions | `accessibility-scan` → `accessibility-fix` → `accessibility-diff` |
| `ship` | Déployer / configurer | `vercel:verification` → `vercel:deploy` (+ `vercel:env`, `vercel:status`) |
| `full` | De zéro à la prod | `build` → `fix` → `ship` |

## Catalogue par besoin

**Direction créative (en choisir UN seul)**
- `bencium-controlled-ux-designer` — l'utilisateur veut garder la main : pose les questions avant chaque décision visuelle, forte contrainte a11y. Défaut si le brief est vague.
- `frontend-design:frontend-design` — interface distinctive et soignée, autonome, rapide. Défaut pour un « fais-le beau » sans plus de contraintes.
- `bencium-impact-designer` — variante « impact » (esthétique marquée, anti-générique AI).
- `bencium-innovative-ux-designer` — langage visuel original, 10 directions typographiques, décision humaine ; seulement si la différenciation de marque est le sujet (coûteux).

**Intelligence de design** : `ui-ux-pro-max` (styles, palettes, typo, UX guidelines, stacks, charts) ; `design-audit` (audit visuel phasé) ; `design-system` + `design:design-system` (tokens, specs composants) ; `design:design-critique`, `design:design-handoff`, `design:ux-copy`.

**Implémentation** : `ui-styling` (shadcn/ui + Tailwind) ; `ui-typography` (règles typo, à appliquer à tout HTML/CSS/JSX généré) ; `vercel:react-best-practices` ; `vercel:nextjs`, `vercel:next-cache-components`, `vercel:next-upgrade` ; `vercel:shadcn` ; `vercel:ai-sdk` / `vercel:chat-sdk` pour l'UI IA.

**Accessibilité (AccessLint)** : `accessibility-scan` (1 page, automatisé) → `accessibility-inspect` (clavier/lecteur d'écran) → `accessibility-audit` (site entier, WCAG-EM) → `accessibility-fix` (remédiation) → `accessibility-diff` (régression/CI). Complément : `design:accessibility-review`.

**Contenu / visibilité** : `bencium-aeo` (SEO pour moteurs IA, FAQ schema) ; `brand`, `banner-design`, `slides`, `design` (identité, bannières, présentations).

**Vercel / ops** : `vercel:deploy`, `vercel:env`, `vercel:env-vars`, `vercel:status`, `vercel:bootstrap`, `vercel:verification`, `vercel:deployments-cicd`, `vercel:vercel-cli`, `vercel:cdn-caching`, `vercel:routing-middleware`, `vercel:vercel-functions`, `vercel:vercel-storage`, `vercel:flags-sdk`, `vercel:auth`. Agents : `vercel:performance-optimizer` (Core Web Vitals), `vercel:deployment-expert`, `vercel:ai-architect`.

**Conventions perso** : `bencium-code-conventions` — à charger seulement si le code est écrit pour Bence.

## Skills absents

Tous les skills cités sont optionnels. Si un skill n'est pas installé, le sauter, le signaler en une ligne, et continuer la chaîne avec les autres. Sur un agent autre que Claude Code, appeler les skills par leur nom simple (sans préfixe `plugin:`).

## Règles de conflit

- Un seul skill de direction créative par tâche ; ne jamais combiner `bencium-controlled` (pose des questions) avec un mode autonome.
- `ui-ux-pro-max` fournit les données (palette, typo, règles), le skill de direction décide du parti pris.
- `ui-typography` s'applique **en dernier** sur le code généré ; `accessibility-*` valide **après** le code.
- Accessibilité en direct : requiert Chrome/DevTools et le serveur MCP AccessLint ; sans eux, se rabattre sur `design:accessibility-review` (revue statique) et le signaler.
- Les outils Vercel nécessitant OAuth (`plugin:vercel:vercel`) doivent être autorisés via `/mcp` ; sinon passer par la CLI (`vercel:vercel-cli`).
- Actions externes (déploiement prod, envoi, suppression) : confirmer avec l'utilisateur avant.

## Exemples

- « Landing page SaaS en Next.js » → `build` : `frontend-design:frontend-design` → `ui-ux-pro-max` → `vercel:nextjs` → `vercel:shadcn` → `ui-typography` → `accessibility-scan`.
- « Mon dashboard est moche et pas accessible » → `audit` puis `fix`.
- « Déploie en preview » → `ship`.
