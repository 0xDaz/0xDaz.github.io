import { defineCollection, z } from 'astro:content';

const blog = defineCollection({
	type: 'content',
	schema: z.object({
		title: z.string(),
		description: z.string().optional(),
		image: z.string().optional(),
		pubDate: z.date(),
		updatedDate: z.date().optional(),
		tags: z.array(z.string()),
		categories: z.array(z.string()),
		draft: z.boolean().default(false),
		translationKey: z.string().optional(),
	}),
});

export const collections = { blog };
