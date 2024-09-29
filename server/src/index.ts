import type { ExportedHandlerFetchHandler } from "@cloudflare/workers-types";

export const onRequest: ExportedHandlerFetchHandler = async (
	request,
	env,
	ctx,
) => {
	const url = new URL(request.url);

	if (url.pathname === "/hoge") {
		return new Response("hoge", {
			headers: { "content-type": "text/plain" },
		});
	}

	const response = new Response("Hello World", {
		headers: { "content-type": "text/plain" },
	});
	return response;
};
