' Heap's permutation algorithm 
'' EViews program that calculates and displays all permutations on logmode
''' Add-in written by : SMIDA Houcine L. 2025
' ------------------------------------------------------------------
' dialog box options 
' ------------------------------------------------------------------
%list = ""
!type = 1
%typelist = """ 1. Permutation list ""  "" 2. Swap list                                                   """
!result = @uidialog("caption", "Heap's permutation algorithm", "edit", %list, "Enter the elements to permute, separated by spaces (e.g., 1 2 3 4, A B C D, Blue Green Red Yellow)", 100000, "text", "Characters $ and £ are not allowed", "text", "If sentences must be swapped, they should be placed in double quotes “ ” ", "radio",!type,"Select what to display",%typelist , "text", "EViews program that calculates all permutations", "text", "Add-in written by : SMIDA Houcine L. 2025") 
' ------------------------------------------------------------------
' use $ and £ as temporary variables
' ------------------------------------------------------------------
if @instr(%list, "$")<>0 or @instr(%list, "£")<>0 then
	@uiprompt("Please don't use the characters $ and £")
	return
endif
' ------------------------------------------------------------------
' choose different elements (without repetition)
' ------------------------------------------------------------------
for !i= 1 to @wcount(%list) -1
	for !j= !i+1 to @wcount(%list)
		if @word(%list,!i)=@word(%list,!j) then
			@uiprompt("Please choose different elements (without repetition)")
			return
		endif
	next
next
' ------------------------------------------------------------------
' maximum number of elements that can be permuted
' ------------------------------------------------------------------
if @wcount(%list) > 10 and !result <> -1 then
	@uiprompt("The maximum number of elements is limited to 10")
	return
endif
' ------------------------------------------------------------------
' display a warning if the list is empty when OK is clicked 
' ------------------------------------------------------------------
if @wcount(%list) < 1 and !result <> -1 then
	@uiprompt("The list is empty, please enter the elements to permute")
	return
endif
' ------------------------------------------------------------------
' If the swap list is selected to be displayed with one element (n = 1)
' ------------------------------------------------------------------
if !type = 2 then
	if @wcount(%list)=1 then
		@uiprompt("No swap, this element can only be permuted with itself")
	endif
endif
' ------------------------------------------------------------------
' stop if the Cancel button is clicked 
' ------------------------------------------------------------------
if !result = -1 then
	stop
endif
' ------------------------------------------------------------------
' logmode settings 
' ------------------------------------------------------------------
logmode(name="Heap_permutation", clear, autosave=off) -all
logmode logmsg
mode ver4  ' version 4 compatibility to remove the double quotes " "
' ------------------------------------------------------------------
' begin subroutine 
' ------------------------------------------------------------------
!n=@wcount(%list)
subroutine Heap(string %list, scalar !n, scalar !i)
	' ------------------------------------------------------------------
	' display options : permutation list 
	' ------------------------------------------------------------------
	if !type=1 then
		if !n=1 then ' Base Case : n=1 
			logmsg %list  ' display the list of permutations
			return
 		else
			call Heap(%list, !n-1, 1) ' recursive call on the first n-1 elements
			for !i=1 to !n-1
				%temp=%list ' check the parity of n 
				if @mod(!n,2)=1 then ' if n is odd, swap the first element with the last
					%list=@wreplace(%list, @word(%list,!n), "$")
					%list=@wreplace(%list, @word(%list,1), "£")
					%list=@wreplace(%list, "$", @word(%temp,1))
					%list=@wreplace(%list, "£", @word(%temp,!n))
				else ' if n is even, swap the i-th element with the last 
					%list=@wreplace(%list, @word(%list,!n), "$")
					%list=@wreplace(%list, @word(%list,!i), "£")
					%list=@wreplace(%list, "$", @word(%temp,!i))
					%list=@wreplace(%list, "£", @word(%temp,!n))
				endif
				call Heap(%list, !n-1, 1) ' recursive call on the first n-1 elements
			next
		endif
	endif
	' ------------------------------------------------------------------
	' display options : swap list 
	' ------------------------------------------------------------------
	if !type=2 then
		if !n=1 then ' Base Case : n=1 
			return
 		else
			call Heap(%list, !n-1, 1) ' recursive call on the first n-1 elements 
			for !i=1 to !n-1
				%temp=%list  ' check the parity of n 
				if @mod(!n,2)=1 then	 ' if n is odd, swap the first element with the last 
					%list=@wreplace(%list, @word(%list,!n), "$")
					%list=@wreplace(%list, @word(%list,1), "£")
					%list=@wreplace(%list, "$", @word(%temp,1))
					%list=@wreplace(%list, "£", @word(%temp,!n))
					%swap=@str(1) + " - " + @str(!n)
				else ' if n is even, swap the i-th element with the last 
					%list=@wreplace(%list, @word(%list,!n), "$")
					%list=@wreplace(%list, @word(%list,!i), "£")
					%list=@wreplace(%list, "$", @word(%temp,!i))
					%list=@wreplace(%list, "£", @word(%temp,!n))
					%swap=@str(!i) + " - " + @str(!n)
				endif
				logmsg %swap ' display the list of swaps
				call Heap(%list, !n-1, 1) ' recursive call on the first n-1 elements 
			next
		endif
	endif
	' ------------------------------------------------------------------
endsub 
' ------------------------------------------------------------------
' end subroutine 
' ------------------------------------------------------------------
call Heap(%list, !n, 1) ' call subroutine


