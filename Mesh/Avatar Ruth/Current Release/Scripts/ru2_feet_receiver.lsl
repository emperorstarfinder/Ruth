//*********************************************************************************    
//**   Copyright (C) 2017  Shin Ingen
//**
//**   This program is free software: you can redistribute it and/or modify
//**   it under the terms of the GNU Affero General Public License as
//**   published by the Free Software Foundation, either version 3 of the
//**   License, or (at your option) any later version.
//**
//**   This program is distributed in the hope that it will be useful,
//**   but WITHOUT ANY WARRANTY; without even the implied warranty of
//**   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//**   GNU Affero General Public License for more details.
//**
//**   You should have received a copy of the GNU Affero General Public License
//**   along with this program.  If not, see <https://www.gnu.org/licenses/>
//*********************************************************************************    
string     targetPrim = "FEET"; //hands|feet
integer     r2chan;
integer     appID = 20181024;
integer     keyapp2chan() 
{
    return 0x80000000 | ((integer)("0x"+(string)llGetOwner()) ^ appID);
}
default
{
    state_entry()
    {
        r2chan = keyapp2chan();
        llListen(r2chan,"","",""); 
    }

    on_rez(integer param) 
    {
        llResetScript();
    }
    
    listen(integer channel,string name,key id,string message)
    {
        if (llGetOwnerKey(id) == llGetOwner()) 
        {
            if (channel == r2chan)
            {
                list msglist = llParseString2List(message, [","], []);
                integer listLenght = llGetListLength(msglist);
                //llOwnerSay("message lenght:"+ (string)listLenght);
                if (listLenght >= 3)
                {
                    string command = llToUpper(llList2String(msglist, 0));
                    if (command == "TEXTURE")
                    {
                        string descflag = llStringTrim(llToUpper(llList2String(msglist, 1)), STRING_TRIM);
                        string textureid = llList2String(msglist, 2);
                        integer i; 
                        integer x = llGetNumberOfPrims()+1; 

                        for (; i < x; ++i)
                        {
                            list paramlist = llGetObjectDetails(llGetLinkKey(i), [OBJECT_DESC,OBJECT_NAME]);
                            string objdesc = llToUpper(llList2String(paramlist,0));
                            string objname = llList2String(paramlist,1);

                            if (objdesc == descflag)
                            {
                                llSetLinkPrimitiveParamsFast(i, [PRIM_TEXTURE, ALL_SIDES, textureid, <1,1,0>, <0,0,0>, 0]);
                            }

                        }
                    } else if (command = "ALPHA")
                    {
                        string prim2change = llStringTrim(llToUpper(llList2String(msglist, 1)), STRING_TRIM);
                        integer face2change = llList2Integer(msglist, 2);
                        integer alphaval = llList2Integer(msglist, 3);
                        integer l = llGetLinkNumber();

                        if (prim2change == targetPrim)
                        {
                            if (face2change == 4) //added to hide toenails when hiding the toes
                            {
                                llSetLinkPrimitiveParamsFast(-2, [PRIM_COLOR, -1, <1.0,1.0,1.0>, alphaval]);
                            }
                            llSetLinkPrimitiveParamsFast(l, [PRIM_COLOR, face2change, <1.0,1.0,1.0>, alphaval]);
                            
                        }
                    }
                }
            }
        } 
    }
}
