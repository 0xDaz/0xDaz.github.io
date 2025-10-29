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
// English uses no prefix, other languages use /lang/ prefix
export function switchLanguage(url: URL, newLang: keyof typeof ui) {
	const currentPath = url.pathname;
	const currentLang = getLangFromUrl(url);

	// If current language is not default (has prefix), remove it
	let newPath = currentPath;
	if (currentLang !== defaultLang) {
		const langPattern = new RegExp(`/(${currentLang})(/|$)`, 'g');
		newPath = currentPath.replace(langPattern, '$2');
		// Ensure path starts with /
		if (!newPath.startsWith('/')) {
			newPath = '/' + newPath;
		}
	}

	// If new language is not default, add prefix
	if (newLang !== defaultLang) {
		newPath = `/${newLang}${newPath}`;
	}

	return newPath;
}
