return {
  {
    "chaoren/vim-wordmotion",
    enabled = false,
  }
}



-- This is one word under Vim's definition:

-- CamelCaseACRONYMWords_underscore1234
-- w--------------------------------->w
-- e--------------------------------->e
-- b<---------------------------------b


-- With this plugin, this becomes six words:

-- CamelCaseACRONYMWords_underscore1234
-- w--->w-->w----->w---->w-------->w->w
-- e-->e-->e----->e--->e--------->e-->e
-- b<---b<--b<-----b<----b<--------b<-b


