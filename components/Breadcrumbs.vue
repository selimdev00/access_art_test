<script setup lang="ts">
import type {
  BreadcrumbItem,
  PageDataTreeNode,
  Locale,
  PageData,
} from "~/types/pageData";

const pageData = inject<PageData>("pageData", null);

const grapNodeValue = (node: PageDataTreeNode, key: "cg_name" | "cg_slug") => {
  const locale: Locale = pageData?.locale || "en";
  const fallbackLocale = locale === "en" ? "ru" : "en";
  return node.locale[locale]?.[key]
    ? node.locale[locale]?.[key]
    : node.locale[fallbackLocale]?.[key];
};

const findTopPath = (node: PageDataTreeNode) => {
  const path = [];

  if (node.path_to_top?.length) {
    for (let i = node.path_to_top.length - 1; i > 0; i--) {
      path.push(`/${grapNodeValue(node.path_to_top[i], "cg_name")}`);
    }
  }

  path.push(`/${grapNodeValue(node, "cg_name")}`);

  return path.join("");
};

const items = computed<BreadcrumbItem[]>(() => {
  const path: BreadcrumbItem[] = [];

  const findPath = (node: PageDataTreeNode) => {
    if (path.find((item) => item.id === node.id)) return;

    if (node.length) {
      node.forEach(findPath);
    } else if (node) {
      if (node.path_to_top) {
        path.push({
          id: node.id,
          name: grapNodeValue(node, "cg_name"),
          path: findTopPath(node),
          depth: node.depth,
        });

        node.path_to_top.forEach(findPath);
      } else {
        path.push({
          id: node.id,
          name: grapNodeValue(node, "cg_name"),
          path: findTopPath(node),
          depth: node.depth,
        });
      }

      if (node.childs) {
        node.childs.forEach(findPath);
      }
    }
  };

  findPath(pageData?.data.page_data.tree);

  path.sort((a, b) => a.depth - b.depth);

  return path;
});

const currentPath = ref<string>("");
const showPath = (path: string) => {
  currentPath.value = path;
};

if (pageData)
  watch(pageData, () => {
    currentPath.value = "";
  });
</script>

<template>
  <div v-if="pageData" class="flex flex-col gap-4">
    <div class="flex items-center gap-2">
      <p>Current language:</p>
      <p class="bg-white rounded-full py-2 px-4 shadow">
        {{ pageData.locale }}
      </p>
    </div>

    <div class="flex items-center gap-2">
      <p>Breadcrumbs:</p>

      <div v-for="(item, index) in items" :key="item.id">
        <span
          class="bg-white rounded-full py-2 px-4 shadow cursor-pointer hover:shadow-lg transition"
          @click="showPath(item.path)"
          >{{ item.name }}</span
        >

        <span v-if="index < items.length - 1"> /</span>
      </div>
    </div>

    <div class="flex items-center gap-2">
      <p>Current path:</p>
      <p class="shadow bg-white py-2 px-4 rounded-full">
        {{ currentPath ? currentPath : "Click on any breadcrumb" }}
      </p>
    </div>
  </div>
  <div v-else>Something went wrong</div>
</template>
