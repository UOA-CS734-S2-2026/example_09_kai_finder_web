import { KaiEventList } from "./features/feed/KaiEventList";
import { sampleEvents } from "./data/fake_event_repository";

export function App() {
  return (
    <div className="app">
      <header className="app__bar">
        <h1>Kai Finder {"\u00B7"} Organiser</h1>
      </header>
      <main className="app__main">
        <KaiEventList events={sampleEvents} />
      </main>
    </div>
  );
}
