export type PageData = {
  data: any;
  status: string;
  locale: Locale;
} | null;

export type Locale = "en" | "ru";

export type PageDataTreeNodeLocale = {
  cg_name: string;
  cg_slug: string;
};

export type PageDataTreeNode = {
  id: number;
  locale: { [key in Locale]: PageDataTreeNodeLocale };
  [key: string]: any;
};

export type BreadcrumbItem = {
  id: number;
  name: string;
  path: string;
  depth: number;
};
