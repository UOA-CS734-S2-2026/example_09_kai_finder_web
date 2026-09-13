import { KaiEventList } from "./features/feed/KaiEventList";
import { SelectionBar } from "./features/feed/SelectionBar";
import { SelectionProvider } from "./state/SelectionContext";
import { sampleEvents } from "./data/fake_event_repository";

export function App() {
  return (
    <SelectionProvider>
      <div className="app">
        <header className="app__bar">
          <h1>Kai Finder {"\u00B7"} Organiser</h1>
        </header>
        <main className="app__main">
          <SelectionBar events={sampleEvents} />
          <KaiEventList events={sampleEvents} />
        </main>
      </div>
    </SelectionProvider>
  );
}
