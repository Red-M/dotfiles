--------------------------------------------------------------------------------
-- Codeblock language lexer
--------------------------------------------------------------------------------

-- Includes
require "utils"


function OnStyle(styler)
    S_WHITESPACE      = 0
    S_DEFAULT         = 32
    S_COMMENT         = 1
    S_KEYWORD         = 2
    S_NUMBER          = 3
    S_STRING          = 4
    S_OPERATOR        = 5
    S_DECLARATION     = 6
    S_SPECIAL_KEYWORD = 7
    S_IDENTIFIER      = 8
    
    -- The string mode specifies which quote character was used to introduce a
    -- string. One can either use " (double quote) or ' (single quote) for a
    -- string-literal.
    STRM_DOUBLE_QUOTE = 1
    STRM_SINGLE_QUOTE = 2
    string_mode       = 0
    
    keywords          = StringSplit(props["keywords.$(file.patterns.codeblock)"],
                                    " ")
    special_keywords  = StringSplit(props["keywords2.$(file.patterns.codeblock)"],
                                    " ")
    number_chars      = "0123456789"
    extra_number_chars= "."
    identifier_chars  = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ" ..
                        "_" .. number_chars
    operator_chars    = "-+*/=<>(){}[]|:,."
    newline_chars     = "\r\n"
    
    is_declaration    = false
    
    ----------------------------------------------------------------------------
    styler:StartStyling(styler.startPos, styler.lengthDoc, styler.initStyle)
    
    while styler:More() do
        -- Exit state if needed
        if is_declaration then
            if newline_chars:find(styler:Current(), 1, true) then
                styler:SetState(S_DECLARATION)
            elseif styler:Current() == "|" then
                is_declaration = false
                styler:ForwardSetState(S_DEFAULT)
            end
        elseif styler:State() == S_NUMBER then
            if not number_chars:find(styler:Current(), 1, true) and 
               not extra_number_chars:find(styler:Current(), 1, true) then
                styler:SetState(S_DEFAULT)
            end
        elseif styler:State() == S_IDENTIFIER then
            if not identifier_chars:find(styler:Current(), 1, true) then
                identifier = styler:Token()
                if TableContainsKey(keywords, identifier) then
                    -- Use ChangeState() here istead of SetState(), since we
                    -- need to change the state of the CURRENT token (which is
                    -- a keyword)
                    styler:ChangeState(S_KEYWORD)
                elseif TableContainsKey(special_keywords, identifier) then
                    styler:ChangeState(S_SPECIAL_KEYWORD)
                end
                
                styler:SetState(S_DEFAULT)
            end
        elseif styler:State() == S_STRING then
            if (string_mode == STRM_SINGLE_QUOTE) and
               (styler:Current() == "'") then
                if styler:Next() == "'" then
                    styler:Forward() -- Skip ...
                else
                    styler:ForwardSetState(S_DEFAULT)
                end
            elseif (string_mode == STRM_DOUBLE_QUOTE) and
                   (styler:Current() == '"') then
                   styler:ForwardSetState(S_DEFAULT)
            end
        elseif (styler:State() == S_OPERATOR) or
               (styler:State() == S_WHITESPACE) then
            styler:SetState(S_DEFAULT)
        elseif styler:State() == S_DECLARATION then
            if styler:Current() == "|" then
                is_declaration = false
                styler:ForwardSetState(S_DEFAULT)
            end
        elseif styler:State() == S_COMMENT then
            if newline_chars:find(styler:Current(), 1, true) then
                styler:SetState(S_DEFAULT)
            end
        end
        
        -- Enter state if needed
        if is_declaration then
            if styler:Match("//") then
                styler:SetState(S_COMMENT)
            end
        elseif styler:State() == S_DEFAULT then
            if styler:Match("//") then
                styler:SetState(S_COMMENT)
            elseif styler:Current() == "'" then
                styler:SetState(S_STRING)
                string_mode = STRM_SINGLE_QUOTE
            elseif styler:Current() == '"' then
                styler:SetState(S_STRING)
                string_mode = STRM_DOUBLE_QUOTE
            elseif operator_chars:find(styler:Current(), 1, true) then
                styler:SetState(S_OPERATOR)
                if styler:Current() == "|" then
                    is_declaration = true
                    styler:SetState(S_DECLARATION)
                end
            elseif number_chars:find(styler:Current(), 1, true) then
                styler:SetState(S_NUMBER)
            elseif identifier_chars:find(styler:Current(), 1, true) then
                styler:SetState(S_IDENTIFIER)
            else
                -- Everything else is treated as whitespaces
                styler:SetState(S_WHITESPACE)
            end
        end
        
        -- Next character ...
        styler:Forward()
    end
    
    styler:EndStyling()
end
