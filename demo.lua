#! /usr/local/bin/lua54

print("Content-Type: text/html\r\n\r\n")

print[[
<!DOCTYPE html>
<HTML>
<HEAD>
<TITLE>Lua: demo</TITLE>
<LINK REL="stylesheet" TYPE="text/css" HREF="https://lua.org/lua.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html; charset=utf-8">
<STYLE TYPE="text/css">
textarea {
	font-family: monospace ;
}

input {
	margin-right: 1em ;	
}
</STYLE>
</HEAD>

<BODY>

<H1>
<A HREF="https://lua.org/home.html"><IMG SRC="https://lua.org/images/logo.gif" ALT="Lua"></A>
Demo
</H1>

<FORM ACTION="/demo.lua" METHOD="POST">
<TEXTAREA ROWS="16" COLS="72" NAME="input" maxlength="2000">]]

-- demo.lua
-- run user programs in constrained environment

local T,E,I

-- convert input  to plain text
T=io.read"*a"
T=string.match(T,"=(.-)$") or ""
T=string.gsub(T,"+"," ")
T=string.gsub(T,"%%(%x%x)",function (x) return string.char(tonumber(x,16)) end)
T=string.gsub(T,"^%s*=%s*","return ")

-- save functions needed at the end
local _G=_G
local collectgarbage=collectgarbage
local pack=table.pack
local print=print
local tostring=tostring
local unpack=table.unpack
local write=io.write

-- continue HTML began in shell script
write(T)
write[[</TEXTAREA>
<P>
<INPUT TYPE="submit" VALUE="run">
<INPUT TYPE="button" VALUE="clear" onclick="this.form.elements['input'].value=''">
<INPUT TYPE="reset" VALUE="restore">
<INPUT TYPE="button" VALUE="restart" onclick="window.location.href='/demo.lua'">
</FORM>

<H2>Output</H2>
<TEXTAREA ROWS="8" COLS="72">]]
io.flush()

-- delete unsafe functions
arg=nil
debug.debug=nil
debug.getfenv=getfenv
debug.getregistry=nil
dofile=nil
io={write=io.write}
loadfile=nil
os.execute=nil
os.getenv=nil
os.remove=nil
os.rename=nil
os.tmpname=nil
package.loaded.io=io
package.loaded.package=nil
package=nil
require=nil

-- run program in global environment
T,E=load(T,"=input","t")
if not T then
	print(E)	E="failed to compile"	I="alert"
else
	T=pack(pcall(T))
	_G.tostring=tostring
	if not T[1] then
		print(T[2])	E="failed to run"	I="alert"
	else
		print(unpack(T,2,T.n))	E="ran successfully"	I="ok"
	end
	collectgarbage()
end

-- continue HTML
write('</TEXTAREA><P><IMG SRC="https://lua.org/images/',I,'.png" ALIGN="absbottom">\n')
write('Your program ',E,'.\n')

