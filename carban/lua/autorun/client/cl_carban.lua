net.Receive("CarBanUserMessage", function()
    Message = net.ReadString()
    chat.AddText(Color(255, 0 ,0), "[Car Ban] : ", Color(0, 255, 0), Message)
end)
