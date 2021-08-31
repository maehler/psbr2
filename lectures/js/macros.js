remark.macros.scale = function(w, alt, caption) {
  if (typeof(alt) === "undefined") {
    console.error("alt text required");
  }
  var url = this;
  var img_tag = `<img src="${url}" alt="${alt}" style="width: ${w};" />`;
  if (typeof(caption) !== "undefined") {
    return `<figure>${img_tag}<figcaption>${caption}</figcaption></figure>`;
  }
  return img_tag;
};