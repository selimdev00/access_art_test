<script setup lang="ts">
import type { PageData } from "~/types/pageData";

const pageData = inject<PageData>("pageData");
</script>

<template>
  <div class="shadow sticky top-0 bg-white">
    <header class="container flex items-center justify-between py-4">
      <Logo />

      <div class="flex items-center gap-4">
        <ul>
          <li>
            <nuxt-link to="/about">About</nuxt-link>
          </li>
        </ul>

        <select
          v-if="pageData"
          name="language"
          id="language"
          v-model="pageData.locale"
        >
          <option value="en">English</option>
          <option value="ru">Russian</option>
        </select>
      </div>
    </header>
  </div>
</template>
