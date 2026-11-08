export type TimelineMessages = {
  workflowLabel: string;
  workflowTitle: string;
  localLane: string;
  branchLane: string;
  later: string;
  initCmd: string;
  initNote: string;
  aiNote: string;
  aiFilesNote: string;
  designFile: string;
  reviewFile: string;
  newCmd: string;
  moveNote: string;
  saveCmd: string;
  saveNote: string;
  clearNote: string;
  listCmd: string;
  listNote: string;
  loadCmd: string;
  loadNote: string;
  branchArtifactCreated: string;
  treeApp: string;
  treeArtifactsDir: string;
  treeArtifactName: string;
  treeReadme: string;
  treeMeta: string;
  treeEmpty: string;
};

export type TreeLine = {
  text: string;
  depth: number;
  accent?: boolean;
  muted?: boolean;
};

export type TimelineNode = {
  id: string;
  title: string;
  detail?: string;
  kind: 'command' | 'ai' | 'state' | 'marker';
  /** Extra top margin before the local file tree. */
  treeSpaced?: boolean;
  localTree?: TreeLine[];
  /** Speech bubble shown under the local file tree. */
  treeNote?: string;
  branch?: {
    detail?: string;
    /** to-branch = local affects branch; to-local = branch restores local */
    direction: 'to-branch' | 'to-local';
    tree?: TreeLine[];
  };
};

export function createTimelineNodes(messages: TimelineMessages): TimelineNode[] {
  const design = messages.designFile;
  const review = messages.reviewFile;
  const artifact = messages.treeArtifactName;

  return [
    {
      id: 'init',
      kind: 'command',
      title: messages.initCmd,
      detail: messages.initNote,
      branch: {
        direction: 'to-branch',
        tree: [
          { text: 'artifacts/', depth: 0, accent: true },
          { text: messages.treeReadme, depth: 1, accent: true },
        ],
      },
    },
    {
      id: 'ai',
      kind: 'ai',
      title: messages.aiNote,
      treeSpaced: true,
      localTree: [
        { text: `${messages.treeApp}/`, depth: 0 },
        { text: design, depth: 1, accent: true },
        { text: review, depth: 1, accent: true },
      ],
      treeNote: messages.aiFilesNote,
    },
    {
      id: 'new',
      kind: 'command',
      title: messages.newCmd,
      detail: messages.branchArtifactCreated,
      localTree: [
        { text: `${messages.treeApp}/`, depth: 0 },
        { text: `${messages.treeArtifactsDir}/`, depth: 1, accent: true },
        { text: `${artifact}/`, depth: 2, accent: true },
        { text: messages.treeEmpty, depth: 3, muted: true },
      ],
      branch: {
        direction: 'to-branch',
        tree: [
          { text: 'artifacts/', depth: 0 },
          { text: messages.treeReadme, depth: 1, muted: true },
          { text: `${artifact}/`, depth: 1, accent: true },
          { text: messages.treeMeta, depth: 2, accent: true },
        ],
      },
    },
    {
      id: 'move',
      kind: 'state',
      title: messages.moveNote,
      treeSpaced: true,
      localTree: [
        { text: `${messages.treeApp}/`, depth: 0 },
        { text: `${messages.treeArtifactsDir}/`, depth: 1, accent: true },
        { text: `${artifact}/`, depth: 2, accent: true },
        { text: design, depth: 3, accent: true },
        { text: review, depth: 3, accent: true },
      ],
    },
    {
      id: 'save',
      kind: 'command',
      title: messages.saveCmd,
      detail: messages.saveNote,
      branch: {
        direction: 'to-branch',
        tree: [
          { text: 'artifacts/', depth: 0 },
          { text: `${artifact}/`, depth: 1, accent: true },
          { text: messages.treeMeta, depth: 2 },
          { text: design, depth: 2, accent: true },
          { text: review, depth: 2, accent: true },
        ],
      },
    },
    {
      id: 'clear',
      kind: 'state',
      title: messages.clearNote,
      localTree: [
        { text: `${messages.treeApp}/`, depth: 0 },
        { text: `${messages.treeArtifactsDir}/`, depth: 1, muted: true },
        { text: messages.treeEmpty, depth: 2, muted: true },
      ],
    },
    {
      id: 'later',
      kind: 'marker',
      title: messages.later,
    },
    {
      id: 'list',
      kind: 'command',
      title: messages.listCmd,
      detail: messages.listNote,
    },
    {
      id: 'load',
      kind: 'command',
      title: messages.loadCmd,
      detail: messages.loadNote,
      localTree: [
        { text: `${messages.treeApp}/`, depth: 0 },
        { text: `${messages.treeArtifactsDir}/`, depth: 1, accent: true },
        { text: `${artifact}/`, depth: 2, accent: true },
        { text: design, depth: 3, accent: true },
        { text: review, depth: 3, accent: true },
      ],
      branch: {
        direction: 'to-local',
        tree: [
          { text: 'artifacts/', depth: 0 },
          { text: `${artifact}/`, depth: 1 },
          { text: messages.treeMeta, depth: 2 },
          { text: design, depth: 2 },
          { text: review, depth: 2 },
        ],
      },
    },
  ];
}
