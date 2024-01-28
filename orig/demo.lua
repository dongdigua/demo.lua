local T,E,I
T=io.read"*a"
T=string.match(T,"=(.-)$") or ""
T=string.gsub(T,"+"," ")
T=string.gsub(T,"%%(%x%x)",function (x) return string.char(tonumber(x,16)) end)
T=string.gsub(T,"^%s*=%s*","return ")

local write=io.write

write(T)
write[[</TEXTAREA>
<P>
<INPUT TYPE="submit" VALUE="Run">
<INPUT TYPE="button" VALUE="Clear" onclick="this.form.elements['input'].value=''">
<INPUT TYPE="reset" VALUE="Original">
</FORM>
<P>

<H2>Output</H2>
<TEXTAREA ROWS="8" COLS="80">
]]
io.flush()

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

T,E=loadstring(T,"=input")
if not T then
	write(E) E="failed to compile" I="alert"
else
	T=(function (...) return {select('#',...),...} end)(pcall(T))
	if not T[2] then
		write(T[3]) E="failed to run" I="alert"
	else
		E="ran successfully" I="ok"
		for i=3,T[1]+1 do write(tostring(T[i]),"\t") end
	end
end
write[[</TEXTAREA><P>]]
write('<IMG SRC="images/',I,'.png" ALIGN="absbottom">\n')
write("Your program ",E,".")
write("<!-- ")
