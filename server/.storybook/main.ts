import type { StorybookConfig } from "@storybook/react-vite";

import path from "node:path";

function getAbsolutePath(value: string): any {
	return path.dirname(require.resolve(path.join(value, "package.json")));
}
const config: StorybookConfig = {
	stories: ["../src/**/*.mdx", "../src/**/*.stories.@(js|jsx|mjs|ts|tsx)"],
	addons: [
		getAbsolutePath("@storybook/addon-onboarding"),
		getAbsolutePath("@storybook/addon-links"),
		getAbsolutePath("@storybook/addon-essentials"),
		getAbsolutePath("@chromatic-com/storybook"),
		getAbsolutePath("@storybook/addon-interactions"),
	],
	framework: {
		name: "@storybook/react-vite",
		options: {},
	},
};
export default config;
