import { FeedScreen } from "./features/feed/FeedScreen";
import { SelectionProvider } from "./state/SelectionContext";
import { RepositoryProvider } from "./state/RepositoryContext";
import type { EventRepository } from "./data/event_repository";

export function App({ repository }: { repository?: EventRepository } = {}) {
  return (
    <RepositoryProvider repository={repository}>
      <SelectionProvider>
        <div className="app">
          <header className="app__bar">
            <h1>Kai Finder {"\u00B7"} Organiser</h1>
          </header>
          <main className="app__main">
            <FeedScreen />
          </main>
        </div>
      </SelectionProvider>
    </RepositoryProvider>
  );
}
