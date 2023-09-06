function Link(el)
  el.attributes.target = "_blank"
  el.content = { pandoc.Span(el.content, { class = "underline" }) }
  return el
end
