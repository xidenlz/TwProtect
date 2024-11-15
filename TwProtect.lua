--[[
        MIT License

        Copyright (c) 2024 xdenlz
        https://github.com/xidenlz/TwProtect
        Permission is hereby granted, free of charge, to any person obtaining a copy
        of this software and associated documentation files (the "Software"), to deal
        in the Software without restriction, including without limitation the rights
        to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
        copies of the Software, and to permit persons to whom the Software is
        furnished to do so, subject to the following conditions:

        The above copyright notice and this permission notice shall be included in all
        copies or substantial portions of the Software.

        THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
        IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
        FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
        AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
        LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
        OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
        SOFTWARE.
--]]
local TwMain = "TwMain"

local function Wrapper(func)
    VMProtect.Begin(func)  

    local MathFactor = math.random(50, 100) 
    local TwLevel = math.ceil(MathFactor * 1.2)  

    for i = 1, TwLevel do
        local asmReg1 = i * MathFactor
        local asmReg2 = asmReg1 ~ 0xAA  
        asmReg1 = (asmReg1 + asmReg2) % 256
        asmReg2 = (asmReg2 - asmReg1) % 256

        if asmReg2 % 2 == 0 then
            asmReg1 = asmReg1 * 2  
        else
            asmReg1 = asmReg1 // 2
        end

        asmReg2 = (asmReg2 + asmReg1 * 3) % 255 
        local asmFlag = asmReg1 < asmReg2  
        if asmFlag then
            asmReg1 = asmReg1 + 0x11  
        else
            asmReg1 = asmReg1 - 0x33  
        end
    end

    VMProtect.End()  
end

local function TwSet()
    local functions = VMProtect.GetFunctionList()  

    for _, func in ipairs(functions) do
        if func == TwMain then
            VMProtect.Virtualize(func)
        else
            Wrapper(func)
        end
    end
end

TwSet()
