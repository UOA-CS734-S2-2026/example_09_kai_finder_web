# Demo controls — operator guide

This repo uses git tags to organise the steps built in class, driven by
`demo.sh` (macOS/Linux) and `demo.ps1` (Windows). Same system as example_05 and
example_06; if you have run those, there is nothing new here.

## The status bar buttons

Opening this folder in VS Code puts six buttons along the bottom: **Prev step**,
**Next step**, **List steps**, **Jump**, **Step 1** and **main**. They come from
the Task Buttons extension (`spencerwmiles.vscode-task-buttons`), which VS Code
offers to install the first time you open the folder.

If the buttons are missing:

- Install the extension. Cmd/Ctrl+Shift+P, `Extensions: Show Recommended
  Extensions`, and take the workspace recommendation.
- Reload afterwards. Cmd/Ctrl+Shift+P, `Developer: Reload Window`. Tasks are
  read at startup.
- Check the folder you opened is this one rather than a parent. VS Code only
  reads `.vscode/` from the workspace root.

Everything the buttons do is also in `Tasks: Run Task`, and in the terminal
commands below. The buttons are a convenience, not a dependency.

## The short version

```
./demo.sh run             # start the Vite dev server on port 5734
./demo.sh list            # show all steps, marking the current one with *
./demo.sh next            # move forward one step
./demo.sh prev            # move back one step
./demo.sh jump 04         # jump straight to step 4
./demo.sh discard-changes # throw away edits, stay put
./demo.sh reset           # leave the demo, back to main
```

On Windows use `.\demo.ps1` instead. If macOS or Linux says "Permission
denied", run `chmod +x demo.sh` first. If PowerShell blocks the script, run
`Set-ExecutionPolicy RemoteSigned -Scope CurrentUser`.

## What happens on a step change

`git reset --hard HEAD`, then `git clean -fd`, then `git checkout <tag>`.

Moving between steps **discards any changes you have made**. That is
intentional: every step is a clean starting point.

`git clean -fd` removes untracked files but never ignored ones, so your
`.env.local` survives every step change.

## The dev server keeps running

Unlike the Flutter demos, nothing needs to be reloaded by hand. Vite watches the
filesystem, so changing step is picked up as a hot module replacement within a
second or so. Leave `./demo.sh run` in its own terminal for the whole lecture.

The one exception is `package.json`. Every dependency is declared from step 1,
so no step needs a second `npm install` and the server never has to restart.

## If the scripts will not run at all

```
git reset --hard HEAD
git clean -fd
git checkout step-04-fetch
```

## Running order for the full lecture demo

Three terminals and an emulator:

1. `cd ../server && npm run dev` — the Kai Events server on 3734
2. `cd web && ./demo.sh run` — this dashboard on 5734
3. `cd ../app && flutter run` — the phone, for the final step

Step 6 is the one that needs all three. If FCM misbehaves in the room, keep the
Firestore console open as a fourth tab: the write still lands live, so the story
survives even if the banner does not appear.
