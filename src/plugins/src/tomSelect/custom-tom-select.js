// Basic
if (document.querySelector("#input-tags")) {
	new TomSelect("#input-tags",{
		persist: false,
		createOnBlur: true,
		create: true
	});
}


// Select Box
if (document.querySelector("#select-beast")) {
	new TomSelect("#select-beast", {
		create: true,
		sortField: {
			field: "text",
			direction: "asc"
		}
	});
}


// Multi Select
if (document.querySelector("#select-state")) {
	new TomSelect("#select-state", {
		maxItems: 3
	});
}


// Disabled Option
if (document.querySelector("#select-beast-single-disabled")) {
	new TomSelect("#select-beast-single-disabled", {
		create: true,
		sortField: { field: "text" }
	});
}


// Disabled Select
if (document.querySelector("#select-beast-disabled")) {
	new TomSelect("#select-beast-disabled");
}
