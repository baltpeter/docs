---
title: LLM prompts
---

These prompts are best used with a model with a long context length, so that you can just paste in large code and/or documentation snippets. I'm hopeful that freely licensed LLMs which can be run locally will catch up sooner rather than later, but for now, I'm using GPT4 through Bing Chat creative mode. 

## Write TSDoc strings

```
Here is the TypeScript source code for TODO:

\`\`\`ts
TODO
\`\`\`

Write detailed and in-depth TSDoc docstrings for everything that is exported (values, functions, types, etc.). For (deeply) nested object types, also write docstrings for every property. Make sure to mention everything that might be useful to the user in great detail, especially gotchas and things that might not be obvious without reading the code.

Only output the docstrings, not the full code.
```

## Write README

Works best if the code already has docstrings.

```
Using this template:

\`\`\`md
TODO
\`\`\`

Write a very detailed and in-depth README for the following library:

\`\`\`ts
TODO
\`\`\`

Remember to explain everything in great detail and don't leave anything out, especially things that might not be obvious (read the code carefully). Do feel free to add additional sections if you think it makes sense. Try to use different examples than those in the docstrings. If anything is unclear, ask me instead of guessing.
```
