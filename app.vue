<script setup lang="ts">
import type { PageData, Locale } from "~/types/pageData";

const { data, status } = await useFetch<PageData>("/api/page_data");
const locale = ref<Locale>(data.value?.locale || "en");

provide<PageData>(
  "pageData",
  reactive({
    data,
    status,
    locale,
  }),
);
</script>

<template>
  <NuxtLayout>
    <NuxtPage />
  </NuxtLayout>
</template>
