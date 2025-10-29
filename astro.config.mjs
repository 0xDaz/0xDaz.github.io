// @ts-check

import mdx from '@astrojs/mdx';
import sitemap from '@astrojs/sitemap';
import { defineConfig } from 'astro/config';

// https://astro.build/config
export default defineConfig({
	site: 'https://0xdaz.github.io',
	i18n: {
		defaultLocale: 'en',
		locales: ['en', 'ko', 'ja', 'zh'],
		routing: {
			prefixDefaultLocale: false,
		},
	},
	integrations: [
		mdx(),
		sitemap({
			i18n: {
				defaultLocale: 'en',
				locales: {
					en: 'en-US',
					ko: 'ko-KR',
					ja: 'ja-JP',
					zh: 'zh-CN',
				},
			},
		}),
	],
});
