import { useEvents } from "../../hooks/useEvents";
import { SelectionBar } from "./SelectionBar";
import { KaiEventList } from "./KaiEventList";

export function FeedScreen() {
  const { events, loading } = useEvents();

  return (
    <section>
      <header className="screen__header">
        <h2>Events</h2>
      </header>

      {loading && <p>Loading\u2026</p>}
      {!loading && events && (
        <>
          <SelectionBar events={events} />
          <KaiEventList events={events} />
        </>
      )}
    </section>
  );
}
