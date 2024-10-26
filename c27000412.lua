--Build Rider - Rabbit Tank
function c27000412.initial_effect(c)
	c:SetUniqueOnField(1,0,27000412)
	-- Link Summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xf15),1,2)

	-- Also WATER Attribute
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED)
	e1:SetCode(EFFECT_ADD_ATTRIBUTE)
	e1:SetValue(ATTRIBUTE_WATER)
	c:RegisterEffect(e1)

	-- Add 1 "Build Driver" or "Build Rider" card from Deck to Hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND + CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP + EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,27000412+1)
	e2:SetTarget(c27000412.search_target)
	e2:SetOperation(c27000412.search_operation)
	c:RegisterEffect(e2)

	-- Negate effects (Quick Effect)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DISABLE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,27000412+2)
	e3:SetTarget(c27000412.distg)
	e3:SetOperation(c27000412.disop)
	c:RegisterEffect(e3)

	-- Restrict control to 1
	c:SetUniqueOnField(1,0,id)
	-- Custom Link Summon condition
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_SPSUMMON_PROC)
	e4:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e4:SetRange(LOCATION_EXTRA)
	e4:SetCondition(c27000412.linkcon)
	e4:SetOperation(c27000412.linkop)
	e4:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e4)
end

-- CUSTOM LINK SUMMON INIT 

-- Material filter
function c27000412.matfilter(c,lc,sumtype,tp)
	return c:IsCode(270000402) and not c:IsDisabled()
end
-- Link Summon using Kiryu
-- Custom Link Summon condition
function c27000412.linkcon(e,c,og)
	if c==nil then return true end
	local tp=c:GetControler()
	local zone=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return zone>0 and Duel.IsExistingMatchingCard(c27000412.matfilter,tp,LOCATION_MZONE,0,1,nil) 
		and Duel.GetMatchingGroupCount(aux.TRUE,tp,LOCATION_MZONE,0,nil)==1
end

-- Custom Link Summon operation
function c27000412.linkop(e,tp,eg,ep,ev,re,r,rp,c,og)
	local tp=c:GetControler()
	local g=Duel.SelectMatchingCard(tp,c27000412.matfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_MATERIAL+REASON_LINK)
end

-- CUSTOM LINK SUMMON END

-- Target function: Select a "Build Driver" or "Build Rider" card from the deck
function c27000412.search_target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c27000412.filter, tp, LOCATION_DECK, 0, 1, nil)
	end
	Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, tp, LOCATION_DECK)
end

-- Operation function: Add the selected card to hand
function c27000412.search_operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp, c27000412.filter, tp, LOCATION_DECK, 0, 1, 1, nil)
	if #g > 0 then
		Duel.SendtoHand(g, nil, REASON_EFFECT)
		Duel.ConfirmCards(1-tp, g)
	end
end

-- Filter function for "Build Driver" or "Build Rider" cards
function c27000412.filter(c)
	return c:IsSetCard(0xf15) and c:IsAbleToHand()
end

-- Negate effect (Quick Effect)
function c27000412.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsNegatableMonster,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsNegatableMonster,tp,0,LOCATION_ONFIELD,1,1,nil)
end
function c27000412.disop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and not tc:IsDisabled() then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		if tc:IsType(TYPE_MONSTER) then
			local atk=tc:GetAttack()/2
			if atk>0 then
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_UPDATE_ATTACK)
				e2:SetValue(atk)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				e:GetHandler():RegisterEffect(e2)
			end
		end
	end
end
