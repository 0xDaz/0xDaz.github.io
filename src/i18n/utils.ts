import { ui, defaultLang } from './ui';

export function getLangFromUrl(url: URL) {
	// Check all path segments for a language code
	// Handles both /lang/... and /blog/lang/... patterns
	const segments = url.pathname.split('/').filter(Boolean);
	for (const segment of segments) {
		if (segment in ui) {
			return segment as keyof typeof ui;
		}
	}
	return defaultLang;
}

export function useTranslations(lang: keyof typeof ui) {
	return function t(key: keyof typeof ui[typeof defaultLang]) {
		return ui[lang][key] || ui[defaultLang][key];
	};
}

export function useTranslatedPath(lang: keyof typeof ui) {
	return function translatePath(path: string, l: string = lang) {
		return !showDefaultLang && l === defaultLang ? path : `/${l}${path}`;
	};
}

export const showDefaultLang = false;

// Switch language while preserving the current path
// Handles both URL prefix patterns (/en/...) and content path patterns (/blog/en/...)
export function switchLanguage(url: URL, newLang: keyof typeof ui) {
	const currentPath = url.pathname;
	const currentLang = getLangFromUrl(url);

	// Replace the current language code with the new one in the path
	// This handles both /lang/... and /blog/lang/... patterns
	const langPattern = new RegExp(`/(${currentLang})(/|$)`, 'g');
	let newPath = currentPath.replace(langPattern, `/${newLang}$2`);

	// If no replacement happened (e.g., /blog without language prefix)
	// Add the language prefix at the start
	if (newPath === currentPath) {
		newPath = `/${newLang}${currentPath}`;
	}

	return newPath;
}
