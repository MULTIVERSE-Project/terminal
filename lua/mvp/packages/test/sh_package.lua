local P = mvp.meta.package:New()

P:SetName("Bobba")
P:SetVersion("1.0.0")
P:SetDescription("UI for Terminal framework")
P:SetAuthor("Kot")

P:SetLicense("MIT")

P:AddDependency("ui")

mvp.package.Register(P)