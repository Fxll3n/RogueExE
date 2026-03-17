# RogueExE — To-Do List (generated 2026-03-16)

This file contains a prioritized, actionable checklist derived from the design document. Each task has a short overview and a tiny example where helpful.

---

## MVP (must-have to run a playable loop)

1) GameState (res://autoload/GameState.gd)
   - Overview: Central source of truth: shell, credits, known_hosts, upgrades, backdoors. Emits signals (shell_changed, credits_changed, host_discovered, node_rooted). Provide helpers (mutate_credits, get_node_data, can_afford, get_upgrade_level).
   - Example: emit_signal("shell_changed", host, user) after connect/exploit success.

2) CommandParser (res://autoload/CommandParser.gd)
   - Overview: Tokenize input, map command names to instances, call execute(args) and return CommandResult. Support register/unregister and get_suggestions(partial) for tab-complete.
   - Example: register("scan", ScanCommand.new()) in _ready().

3) JobManager (res://autoload/JobManager.gd)
   - Overview: Owns Timer nodes, manages job lifecycle: tick  emit job_tick(id,line)  check is_done  emit job_done or job_cancelled. Never prints directly.
   - Example: add_job(job) creates a Timer whose timeout calls job.tick().

4) SaveManager (res://autoload/SaveManager.gd)
   - Overview: Serialize/restore GameState and NodeData only. On load reset shell to home/player. Restart PassiveJob for backdoors after loading.
   - Example save shape: {credits, known_hosts, upgrades, backdoors, nodes: {ip: {vulns, loot_remaining, trace_level, has_creds, backdoored}}}.

5) TerminalUI Scene (res://scenes/TerminalUI.tscn)
   - Overview: LineEdit for input, RichTextLabel for scrollback, single HUD label at bottom. Send input to CommandParser and print CommandResult. Listen to JobManager signals to append job lines.
   - Example HUD: "₿ 4,821  │  jobs: exfil(23%)  scan(done)  │  trace: low"

6) CommandResult + BaseCommand (res://commands/)
   - Overview: CommandResult static constructors (OK/ERROR/WARN/ASYNC/SILENT). BaseCommand enforces required_state gating and provides helpers (_require_args, _get_node_data). Commands should not bypass these utilities.
   - Example: return CommandResult.async_start("scanning...", ScanJob.new()) when spawning jobs.

7) Core commands (MVP subset)
   - Overview: Implement scan, connect, probe, exploit, exfil, disconnect, help, clear, status, jobs as BaseCommand subclasses. Respect required_state.
   - Example: scan (LOCAL) spawns ScanJob; connect <ip> switches shell on success.

---

## Core systems & gameplay rules

8) Jobs implementations (res://jobs/)
   - Overview: BaseJob, ScanJob, ProbeJob, ExfilJob, PassiveJob (and optional CrackJob). Jobs emit progress via JobManager signals and modify GameState/NodeData through APIs.
   - Example: ExfilJob tick reduces node.loot_remaining and calls GameState.mutate_credits(loot_tick).

9) Data objects (res://data/NodeData.gd, UpgradeData.gd)
   - Overview: NodeData (ip, difficulty, loot_remaining, vulns[], trace_level, has_creds, backdoored). UpgradeData holds upgrade definitions and base values for balancing.
   - Example: GameState.get_upgrade_level("scan_speed") used to compute ScanJob intervals.

10) Trace mechanics & gating
   - Overview: Per-node trace that increments while connected/rooted; overflow forces disconnect, cancels ExfilJob, and causes partial loot loss. Wipe reduces trace by wipe_power.
   - Example: failed exploit adds +15 spike; wipe command subtracts wipe_power.

11) Exfil & Backdoor persistence
   - Overview: ExfilJob drains loot over time; backdoor grants PassiveJob passive income and sets node.backdoored.
   - Example: PassiveJob ticks every second and calls mutate_credits for each backdoored node.

---

## UX, polish & QoL

12) Tab-complete & Help
   - Overview: CommandParser.get_suggestions and automatic HelpCommand that prints BaseCommand.usage/description for each registered command.
   - Example: typing "pro" and pressing tab suggests "probe".

13) Job inspector & cancellation (JobsCommand)
   - Overview: list active jobs with percent complete and allow cancel by id. JobManager must emit job_cancelled and clean up timers.
   - Example: "jobs cancel 3" cancels job id 3.

14) HUD & trace warnings
   - Overview: Bottom HUD shows credits, active jobs summary, and current trace status (low/med/high). Use icons/colors for quick scanning.
   - Example: "₿ 1,234 │ jobs: exfil(47%) │ trace: HIGH"

15) Buy/shop & upgrades
   - Overview: BuyCommand reads UpgradeData, deducts credits via GameState.mutate_credits, and increments GameState.upgrades. Implement cost scaling.
   - Example: buy scan_speed (cost 200) → upgrades["scan_speed"] += 1.

---

## Balancing, design docs & tuning

16) Loot/economy tuning doc
   - Overview: Small table or text file with loot_by_difficulty, upgrade_costs, exfil_tick values, trace tick rates and thresholds. Essential for balancing.
   - Example: difficulty 1 hosts: loot 100, exfil_tick 5 → $1/tick at x ticks.

17) Progression & unlocks
   - Overview: Define how vuln types, host difficulties, and upgrade caps unlock as player buys/upgrades or reaches milestones.

---

## Developer tooling & testing

18) Debug/dev commands
   - Overview: spawn-node, set-credits, cheat-upgrade for fast iteration. Wrap with a dev-only flag so they can be excluded for a release build.
   - Example: dev set-credits 10000

19) Playtest scenes / harness
   - Overview: Small scenes that create a known host and run a scan→probe→exploit→exfil cycle automatically to verify transitions without manual input.

20) Logging & save safety
   - Overview: Verbose dev logging toggle, safe-save backups, and graceful recovery from corrupted save files.

---

## Assets, accessibility & release

21) Terminal visuals & font
   - Overview: Choose a monospace font, color palette, and minimal sound cues for success/failure. HUD must remain non-scrolling.

22) Accessibility
   - Overview: Keyboard-only operation, high-contrast mode, scalable fonts.

23) Packaging & README
   - Overview: Update README with controls, build/export steps, and a note about No-AI jam compliance. Add CONTRIBUTING.md for reviewers.

---

## Polish & extras (post-MVP)

24) Wipe/stealth enhancements
   - Overview: Add cooldowns, visual feedback, and upgrade synergies for wipe/trace mechanics.

25) Multi-host operations & macros (optional)
   - Overview: Allow scripted macros or job chaining for advanced players; keep out of MVP unless time allows.

---

## Next steps (suggested)
- Review and edit this todo.md locally if you want different priorities.
- If desired, export these items into the session todo DB or create plan.md for implementation tracking.

(End of file)
