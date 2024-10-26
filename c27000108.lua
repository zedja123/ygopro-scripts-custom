--Wiccanthrope Wataquera
function c27000108.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,2,nil,nil,nil,nil,false,c27000108.xyzcheck)
	c:EnableReviveLimit()

	-- Attach 1 Spell/Trap card on field to this card when Xyz Summoned
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(27000108,0))
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,27000108)
	e1:SetCondition(c27000108.xyzcon)
	e1:SetTarget(c27000108.xyztg)
	e1:SetOperation(c27000108.xyzop)
	c:RegisterEffect(e1)

	-- Quick Effect: Detach 1 material to destroy 1 card, then set 1 "Wiccanthrope" Spell directly from Deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(27000108,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,27000108+1)
	e2:SetCost(c27000108.detachcost)
	e2:SetTarget(c27000108.detachtg)
	e2:SetOperation(c27000108.detachop)
	c:RegisterEffect(e2)
end

function c27000108.xyzfilter(c,xyz,tp)
	return c:IsSetCard(0xf11,xyz,SUMMON_TYPE_XYZ,tp)
end
function c27000108.xyzcheck(g,tp,xyz)
	return g:IsExists(c27000108.xyzfilter,1,nil,xyz,tp)
end

function c27000108.xyzcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end

function c27000108.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,TYPE_SPELL+TYPE_TRAP) end
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,nil,1,tp,LOCATION_MZONE)
end

function c27000108.xyzop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,TYPE_SPELL+TYPE_TRAP)
	if #g>0 then
		Duel.Overlay(e:GetHandler(),g)
	end
end

function c27000108.detachcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end

function c27000108.banfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToRemoveAsCost()
end

function c27000108.setfilter(c)
	return c:IsType(TYPE_QUICKPLAY) and c:IsSSetable() and c:IsSetCard(0xf11)
end
function c27000108.detachtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end

function c27000108.detachop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		if Duel.IsExistingMatchingCard(c27000108.banfilter,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil) 
			and Duel.SelectYesNo(tp,aux.Stringid(27000108,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local sg=Duel.SelectMatchingCard(tp,c27000108.banfilter,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,1,1,nil)
			if Duel.Remove(sg,POS_FACEUP,REASON_COST)~=0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
				local sc=Duel.SelectMatchingCard(tp,c27000108.setfilter,tp,LOCATION_DECK,0,1,1,nil)
				if #sc>0 then
						Duel.SSet(tp,sc)
						Duel.ConfirmCards(1-tp,sc)
						local e1=Effect.CreateEffect(e:GetHandler())
						e1:SetType(EFFECT_TYPE_SINGLE)
						e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
						e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
						e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				end
			end
		end
	end
end