import {
  useEffect,
  useLayoutEffect,
  useMemo,
  useRef,
  useState,
  type ReactNode,
} from 'react';
import {
  createTimelineNodes,
  type TimelineMessages,
  type TimelineNode,
  type TreeLine,
} from '../data/artifact-timeline-scenario';

export type { TimelineMessages } from '../data/artifact-timeline-scenario';

function CommandBox({ title, active }: { title: string; active: boolean }) {
  return (
    <div
      className={[
        'rounded-md border px-3 py-2 font-mono text-[12px] leading-snug font-medium transition-colors duration-300 sm:text-[13px]',
        active
          ? 'border-[color-mix(in_oklab,var(--accent)_55%,var(--border))] bg-[var(--navy)] text-white'
          : 'border-[var(--border)] bg-[color-mix(in_oklab,var(--navy)_88%,black)] text-white/85',
      ].join(' ')}
    >
      <span className="mr-2 text-white/45">$</span>
      {title}
    </div>
  );
}

function EventBox({ title, active }: { title: string; active: boolean }) {
  return (
    <div
      className={[
        'rounded-md border px-3 py-2 text-[13px] leading-snug font-medium transition-colors duration-300',
        active
          ? 'border-[var(--border)] bg-[var(--bg-elevated)] text-[var(--fg)]'
          : 'border-[var(--border)] bg-[var(--bg-elevated)] text-[var(--fg-muted)] opacity-65',
      ].join(' ')}
    >
      {title}
    </div>
  );
}

function SpeechBubble({ text, active }: { text: string; active: boolean }) {
  return (
    <div
      className={[
        'relative mt-2 rounded-lg border px-3 py-2 text-[12px] leading-snug transition-colors duration-300 sm:text-[13px]',
        active
          ? 'border-[var(--border)] bg-[var(--bg-elevated)] text-[var(--fg)]'
          : 'border-[var(--border)] bg-[var(--bg-elevated)] text-[var(--fg-muted)] opacity-65',
      ].join(' ')}
    >
      <span
        className="absolute -top-1.5 left-5 h-3 w-3 rotate-45 border-t border-l border-[var(--border)] bg-[var(--bg-elevated)]"
        aria-hidden="true"
      />
      {text}
    </div>
  );
}

function FileTreePanel({ lines, active }: { lines: TreeLine[]; active: boolean }) {
  return (
    <div
      className={[
        'overflow-hidden rounded-md border transition-colors duration-300',
        active
          ? 'border-[color-mix(in_oklab,var(--accent)_40%,var(--border))] bg-[var(--bg)]'
          : 'border-[var(--border)] bg-[var(--bg)] opacity-60',
      ].join(' ')}
    >
      <div className="border-b border-[var(--border)] px-2.5 py-1 font-mono text-[10px] tracking-wide text-[var(--fg-muted)] uppercase">
        tree
      </div>
      <ul className="space-y-0.5 px-2.5 py-2 font-mono text-[11px] leading-5 sm:text-[12px]">
        {lines.map((line, index) => (
          <li
            key={`${line.text}-${index}`}
            className={
              line.accent
                ? 'font-medium text-[var(--accent)]'
                : line.muted
                  ? 'text-[var(--fg-muted)] opacity-70'
                  : 'text-[var(--fg)]'
            }
            style={{ paddingLeft: `${line.depth * 0.75}rem` }}
          >
            {line.text}
          </li>
        ))}
      </ul>
    </div>
  );
}

function BoxArrowRow({
  id,
  direction,
  active,
  left,
  leftBelow,
  right,
}: {
  id: string;
  direction: 'to-branch' | 'to-local';
  active: boolean;
  left: ReactNode;
  leftBelow?: ReactNode;
  right: ReactNode;
}) {
  const rowRef = useRef<HTMLDivElement>(null);
  const leftRef = useRef<HTMLDivElement>(null);
  const rightRef = useRef<HTMLDivElement>(null);
  const [geom, setGeom] = useState<{ x1: number; x2: number; y: number } | null>(null);
  const markerId = `timeline-arrow-${id}`;

  useLayoutEffect(() => {
    const row = rowRef.current;
    const leftEl = leftRef.current;
    const rightEl = rightRef.current;
    if (!row || !leftEl || !rightEl) return;

    function measure() {
      if (!row || !leftEl || !rightEl) return;
      const rowBox = row.getBoundingClientRect();
      const leftBox = leftEl.getBoundingClientRect();
      const rightBox = rightEl.getBoundingClientRect();
      setGeom({
        x1: leftBox.right - rowBox.left,
        x2: rightBox.left - rowBox.left,
        y: (leftBox.top + leftBox.bottom) / 2 - rowBox.top,
      });
    }

    measure();
    const observer = new ResizeObserver(measure);
    observer.observe(row);
    observer.observe(leftEl);
    observer.observe(rightEl);
    window.addEventListener('resize', measure);
    return () => {
      observer.disconnect();
      window.removeEventListener('resize', measure);
    };
  }, []);

  const toBranch = direction === 'to-branch';

  return (
    <div ref={rowRef} className="relative grid grid-cols-2 items-start gap-4 sm:gap-8">
      <div className="relative z-10 mx-auto w-[min(100%,20rem)]">
        <div ref={leftRef}>{left}</div>
        {leftBelow}
      </div>
      <div ref={rightRef} className="relative z-10 mx-auto w-[min(100%,20rem)]">
        {right}
      </div>

      {geom && geom.x2 - geom.x1 > 8 ? (
        <svg
          className={[
            'pointer-events-none absolute inset-0 z-[5] h-full w-full overflow-visible transition-opacity duration-300',
            active ? 'opacity-100' : 'opacity-40',
          ].join(' ')}
          aria-hidden="true"
        >
          <defs>
            <marker id={markerId} markerWidth="8" markerHeight="8" refX="7" refY="4" orient="auto">
              <path d="M0 0 L8 4 L0 8 Z" fill="var(--accent)" />
            </marker>
          </defs>
          <line
            x1={toBranch ? geom.x1 : geom.x2}
            y1={geom.y}
            x2={toBranch ? geom.x2 : geom.x1}
            y2={geom.y}
            stroke="var(--accent)"
            strokeWidth="1.75"
            strokeDasharray={toBranch ? undefined : '4 3'}
            markerEnd={`url(#${markerId})`}
          />
        </svg>
      ) : null}
    </div>
  );
}

export default function ArtifactTimelineDemo({ messages }: { messages: TimelineMessages }) {
  const nodes = useMemo(() => createTimelineNodes(messages), [messages]);
  const stepRefs = useRef<(HTMLElement | null)[]>([]);
  const [activeIndex, setActiveIndex] = useState(0);

  useEffect(() => {
    function update() {
      const viewport = window.innerHeight * 0.42;
      let next = 0;
      for (let i = 0; i < stepRefs.current.length; i += 1) {
        const el = stepRefs.current[i];
        if (!el) continue;
        if (el.getBoundingClientRect().top <= viewport) next = i;
      }
      setActiveIndex(next);
    }

    update();
    window.addEventListener('scroll', update, { passive: true });
    window.addEventListener('resize', update);
    return () => {
      window.removeEventListener('scroll', update);
      window.removeEventListener('resize', update);
    };
  }, [nodes]);

  return (
    <section className="relative w-full" aria-label={messages.workflowLabel}>
      <h2 className="mb-8 font-sans text-2xl font-bold tracking-tight text-[var(--fg)] sm:mb-10 sm:text-3xl">
        {messages.workflowTitle}
      </h2>

      <div className="sticky top-16 z-10 -mx-4 mb-4 grid grid-cols-2 gap-4 bg-[color-mix(in_oklab,var(--bg)_90%,transparent)] px-4 py-3 backdrop-blur-sm sm:-mx-6 sm:gap-8 sm:px-6 lg:top-20">
        <div className="flex justify-center">
          <p className="rounded-md border border-[var(--border)] bg-[var(--bg-elevated)] px-3 py-1.5 text-center text-[11px] font-semibold tracking-wide text-[var(--fg)] uppercase sm:text-xs">
            {messages.localLane}
          </p>
        </div>
        <div className="flex justify-center">
          <p className="rounded-md border border-[var(--border)] bg-[var(--bg-elevated)] px-3 py-1.5 text-center text-[11px] font-semibold tracking-wide text-[var(--fg)] uppercase sm:text-xs">
            {messages.branchLane}
          </p>
        </div>
      </div>

      <div className="relative">
        <div className="pointer-events-none absolute inset-y-0 left-0 grid w-full grid-cols-2 gap-4 sm:gap-8" aria-hidden="true">
          <div className="relative">
            <div className="absolute inset-y-0 left-1/2 w-px -translate-x-1/2 bg-[var(--border)]" />
          </div>
          <div className="relative">
            <div className="absolute inset-y-0 left-1/2 w-px -translate-x-1/2 bg-[var(--border)]" />
          </div>
        </div>

        <ol className="relative space-y-16 pt-2 pb-6 sm:space-y-20">
          {nodes.map((node, index) => {
            const active = index === activeIndex;
            const hasInteraction = Boolean(node.branch);

            if (node.kind === 'marker') {
              return (
                <li
                  key={node.id}
                  ref={(el) => {
                    stepRefs.current[index] = el;
                  }}
                  className="relative flex justify-center py-2"
                >
                  <div
                    className={[
                      'rounded-full border px-4 py-1.5 text-[11px] font-semibold tracking-wide uppercase transition-colors duration-300',
                      active
                        ? 'border-[var(--accent)] bg-[var(--accent-soft)] text-[var(--accent)]'
                        : 'border-[var(--border)] bg-[var(--bg)] text-[var(--fg-muted)]',
                    ].join(' ')}
                  >
                    {node.title}
                  </div>
                </li>
              );
            }

            const localPrimary =
              node.kind === 'command' ? (
                <CommandBox title={node.title} active={active} />
              ) : (
                <EventBox title={node.title} active={active} />
              );

            return (
              <li
                key={node.id}
                ref={(el) => {
                  stepRefs.current[index] = el;
                }}
                className="relative"
              >
                {hasInteraction ? (
                  <BoxArrowRow
                    id={node.id}
                    direction={node.branch!.direction}
                    active={active}
                    left={localPrimary}
                    leftBelow={
                      <>
                        {node.detail ? <SpeechBubble text={node.detail} active={active} /> : null}
                        {node.localTree ? (
                          <div className={node.treeSpaced ? 'mt-8' : 'mt-2'}>
                            <FileTreePanel lines={node.localTree} active={active} />
                          </div>
                        ) : null}
                        {node.treeNote ? <SpeechBubble text={node.treeNote} active={active} /> : null}
                      </>
                    }
                    right={
                      node.branch!.tree ? (
                        <FileTreePanel lines={node.branch!.tree} active={active} />
                      ) : null
                    }
                  />
                ) : (
                  <div className="grid grid-cols-2 gap-4 sm:gap-8">
                    <div className="mx-auto w-[min(100%,20rem)]">
                      {localPrimary}
                      {node.detail ? <SpeechBubble text={node.detail} active={active} /> : null}
                      {node.localTree ? (
                        <div className={node.treeSpaced ? 'mt-8' : 'mt-2'}>
                          <FileTreePanel lines={node.localTree} active={active} />
                        </div>
                      ) : null}
                      {node.treeNote ? <SpeechBubble text={node.treeNote} active={active} /> : null}
                    </div>
                    <div />
                  </div>
                )}
              </li>
            );
          })}
        </ol>
      </div>
    </section>
  );
}
