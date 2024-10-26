--ヒーロースピリッツ
---@param c Card
function c81167171.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCondition(c81167171.condition)
	e1:SetOperation(c81167171.activate)
	c:RegisterEffect(e1)
	if not c81167171.global_check then
		c81167171.global_check=true
		c81167171[0]=false
		c81167171[1]=false
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_BATTLE_DESTROYED)
		ge1:SetOperation(c81167171.checkop1)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(c81167171.clear)
		Duel.RegisterEffect(ge2,0)
	end
end
function c81167171.checkop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsPreviousSetCard(0x3008) then
			c81167171[tc:GetPreviousControler()]=true
		end
		tc=eg:GetNext()
	end
end
function c81167171.clear(e,tp,eg,ep,ev,re,r,rp)
	c81167171[0]=false
	c81167171[1]=false
end
function c81167171.condition(e,tp,eg,ep,ev,re,r,rp)
	return c81167171[tp] and (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE)
end
function c81167171.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_NO_BATTLE_DAMAGE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetReset(RESET_PHASE+PHASE_BATTLE+PHASE_DAMAGE_CAL)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetValue(1)
	e2:SetReset(RESET_PHASE+PHASE_BATTLE+PHASE_DAMAGE_CAL)
	Duel.RegisterEffect(e2,tp)
end
