# Kai Finder, on the web

The live-coding demo for **COMPSCI 734, Lecture 12 (Week 07): Web Frontends with React**.

Kai Finder has had a phone client since Week 02 and a real backend since Week 05.
It has never had anywhere to *post* an event. The organiser has to type a name, a
location and a portion count, and that is not something you do with one thumb.
This repo is that missing client.

It is the **organiser dashboard**: read-heavy on the phone, write-heavy here. The
two clients are not the same product rendered twice. They are different jobs
against one API.

The write goes through the server, exactly as the phone's writes do. That is not
a stylistic preference — `server/firestore.rules` denies client writes outright,
so a browser write is rejected before it reaches anything.

## Built and tested with

```
Node.js v20 or newer
npm 10 or newer
```

Dependencies are pinned to exact versions so the demo cannot drift:

| Package                       | Version |
| ----------------------------- | ------- |
| `react`                       | 18.3.1  |
| `vite`                        | 5.4.11  |
| `typescript`                  | 5.9.3   |
| `vitest`                      | 2.1.8   |
| `@testing-library/react`      | 16.1.0  |
| `@testing-library/user-event` | 14.5.2  |
| `jsdom`                       | 25.0.1  |

## Running it

The dashboard needs something to talk to. Two options; the first is the one
the lecture uses.

### Option A — example_06, with Firebase

```
cd ../example_06_kai_firebase/server
npm install
npm run seed
npm run dev
```

Then, here:

```
npm install
npm run dev
```

The full thing: events persist in Firestore, and posting from the dashboard
sends a real FCM broadcast. Needs your own Firebase project and a service
account key, as set up for the Firebase lecture.

**Run `npm run seed` before the first `npm run dev`.** Without it Firestore is
empty, and the dashboard correctly shows its empty state — which looks like a
bug when you were expecting six events. Seeding uses fixed document ids, so
running it again overwrites rather than duplicates, and it is the fastest way
back to a clean demo.

**Stop the server when you are not using it.** Portions decay every fifteen
seconds and every tick writes to Firestore. The free tier allows 20,000 writes
a day, which is plenty for a lecture and not plenty for a server left running
overnight.

### Option B — the bundled dev server (no credentials, no setup)

Two terminals. In the first:

```
npm install
npm run kai-server
```

In the second:

```
npm run dev
```

`npm run kai-server` runs `tools/kai-dev-server.mjs`: the Kai Events API held in
memory, with no dependencies beyond Node itself. It has the REST surface of
example_05 plus the `postEvent` mutation from example_06, so everything works
with nothing to configure. It prints the FCM broadcast it would have sent
instead of sending one.

### Either way

The dashboard listens on **<http://localhost:5734>** and expects a server on
**<http://localhost:3734>**. Copy `.env.example` to `.env.local` to point it
elsewhere, and restart the dev server afterwards — Vite reads env files only at
startup.

**Every Kai server binds port 3734**, including the bundled one. Run exactly one
of them. `EADDRINUSE` on startup means another is already running; `lsof -ti:3734
| xargs kill` on macOS or Linux, or `netstat -ano | findstr :3734` then
`taskkill /PID <pid> /F` on Windows.

All of these are interchangeable from the browser's point of view, which is
worth a sentence in the lecture: the client is written against an interface, so
replacing the implementation underneath changes nothing above it. That is the
same argument that lets the tests substitute `FakeEventRepository`.

**No `10.0.2.2` this time.** The Flutter app needs that address because it runs
inside the Android emulator and has to reach out to the host machine. The
browser *is* on the host, so `localhost` works.

**If the feed shows the error state but `curl localhost:3734/events` works**,
suspect CORS: the browser is being refused where curl is not. Check with

```
curl -i -H "Origin: http://localhost:5734" localhost:3734/events | grep -i access-control
```

An `Access-Control-Allow-Origin` header means CORS is fine and the problem is
elsewhere. No header means the server needs `app.use(cors())` above its routes.

`npm test` runs the suite. `npm run typecheck` runs `tsc --noEmit`. `npm run
build` runs both, then bundles into `dist/`.

## What it does

| Screen     | What it is                                                                 |
| ---------- | -------------------------------------------------------------------------- |
| **Events** | The feed, with search, favourites, and a My events / All events scope. All four states: loading, error, empty, success. |
| **Post**   | The organiser form. Writes via the `postEvent` GraphQL mutation, which is what triggers the FCM broadcast. |

Reads go over REST (`GET /events`). The write goes over GraphQL, because
`postEvent` only exists as a mutation.



## The steps

| Step | Tag | New ideas | What changes |
| ---- | --- | --------- | ------------ |
| 1 | `step-01-scaffold` | Vite, `index.html`, `main.tsx`, the npm scripts | What `npm create vite@latest -- --template react-ts` produces, with the demo boilerplate removed. Five files under `src/`, and an app that renders one line |
| 2 | `step-02-card` | components, props, JSX | `KaiEventCard`, rendering one hard-coded event |
| 3 | `step-03-list` | `.map()`, and **`key`** | Four events. Key by index first, watch it break, then key by `event.id` |
| 4 | `step-04-selection` | `useState`, Context, immutability | A checkbox per row and a bar totalling what is ticked. Mutating the Set instead of replacing it is the bug worth showing here |
| 5 | `step-05-fetch` | `useEffect`, the dependency array, cleanup | Real data from `GET /events`. Omit the array first and watch the loop in the network tab |
| 6 | `step-06-states` | loading, error, **empty**, data | Skeleton, plain-language error with retry, two different empty states, and search |
| 7 | `step-07-post` | writing through the API | The organiser form, posting via the `postEvent` mutation |
| 8 | `step-08-who-posted` | attribution, and what is not verified | The acting-as selector, `postedById` on every write, and the My events scope |

`main` sits at the final step, so a plain clone gives you the finished dashboard.

**A note on versions.** This project pins React 18. Running `npm create vite@latest`
today gives you React 19, TypeScript 6 and Vite 8. Nothing in these steps differs
between the two — every hook, rule and bug is identical — but the version numbers
in a freshly scaffolded project will not match the ones here.

### Rebuilding the step tags

The tags are generated from `main`, so edit `main` and then regenerate:

```
./tools/build-steps.sh
```

Each step checks out the finished tree, removes what that step has not
introduced yet, swaps in the variants from `tools/steps/`, and commits. Every
tag typechecks on its own.

### How to use the demo scripts

This project uses git tags to organise the steps we build in class. Navigate
them with the provided scripts:

```
./demo.sh run             # Start the dev server
./demo.sh list            # Show all available steps
./demo.sh next            # Move to the next step
./demo.sh prev            # Move to the previous step
./demo.sh jump 04         # Jump to a specific step
./demo.sh discard-changes # Throw away your changes, stay on this step
./demo.sh reset           # Leave the demo, return to the main branch
```

On Windows use `.\demo.ps1` instead of `./demo.sh`. If you get "Permission
denied" on macOS or Linux, run `chmod +x demo.sh` first. If PowerShell blocks
the script, run `Set-ExecutionPolicy RemoteSigned -Scope CurrentUser`.

Run `npm install` once before you start stepping. Every dependency is declared
from step 1, so no step ever needs a second install, and Vite hot-reloads across
a step change without restarting.

Moving between steps **discards any changes you have made**. That is
intentional: every step is a clean starting point. If the scripts will not run
at all, you can do the same thing by hand:

```
git reset --hard HEAD
git clean -fd
git checkout step-04-fetch
```

`DEMO-CONTROLS.md` is the full operator guide for the stepping system.

## Reading it beside the Flutter app

The folder layout deliberately mirrors `app/lib/`, so the two can sit side by
side on screen:

| Flutter                                      | Here                                |
| -------------------------------------------- | ----------------------------------- |
| `lib/data/kai_event.dart`                    | `src/data/kai_event.ts`             |
| `lib/data/services/api_service.dart`         | `src/data/kai_api_service.ts`       |
| `lib/data/repositories/`                     | `src/data/event_repository.ts`      |
| `EventsViewModel` + `ChangeNotifierProvider` | `src/state/SelectionContext.tsx`   |
| `EventsViewModel.load()`                     | `src/hooks/useEvents.ts`            |
| `lib/features/feed/`                         | `src/features/feed/`                |
| `test/fakes/fake_event_repository.dart`      | `src/data/fake_event_repository.ts` |

## Tests

23 tests, and not optional decoration — the Week 03 testing lecture set the bar
at every widget, every state and the accessibility guidelines, and Week 07
should not quietly lower it.

```
npm test
```

They run against `FakeEventRepository`, so nothing touches the network and the
whole suite finishes in a couple of seconds. Queries go through roles and
accessible names rather than class names, which keeps them working through
refactors and checks the accessible names exist at the same time.
