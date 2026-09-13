import { KaiEventCard } from "./features/feed/KaiEventCard";

const SAMOSAS = {
  id: "free-samosas",
  name: "Free samosas",
  location: "OGGB Level 2",
  emoji: "\u{1F95F}",
  portionsLeft: 14,
  isActive: true,
  lat: -36.8523,
  lng: 174.7691,
  postedById: "u1",
};

export function App() {
  return (
    <div className="app">
      <header className="app__bar">
        <h1>Kai Finder {"\u00B7"} Organiser</h1>
      </header>
      <main className="app__main">
        <KaiEventCard event={SAMOSAS} />
      </main>
    </div>
  );
}
