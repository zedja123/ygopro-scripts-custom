-- Ashens Ruler - Yhorm
function c27000208.initial_effect(c)
	-- Special Summon when sent to the GY
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCountLimit(1,27000208+1)
	e1:SetCondition(c27000208.spcon)
	e1:SetTarget(c27000208.sptg)
	e1:SetOperation(c27000208.spop)
	c:RegisterEffect(e1)

	-- Send to GY to Special Summon from Deck
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,27000208+2)
	e2:SetTarget(c27000208.sptg2)
	e2:SetOperation(c27000208.spop2)
	c:RegisterEffect(e2)

	-- Quick Effect: Destroy 1 Spell/Trap card
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(function(e,tp) return Duel.IsTurnPlayer(1-tp) end)
	e3:SetCountLimit(1,27000208+3)
	e3:SetTarget(c27000208.destg)
	e3:SetOperation(c27000208.desop)
	c:RegisterEffect(e3)
end

-- Special Summon when sent to the GY condition
function c27000208.spcon(e,tp,eg,ep,ev,re,r,rp)
	return re and not re:GetHandler():IsCode(id)
end

-- Special Summon when sent to the GY target
function c27000208.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end

-- Special Summon when sent to the GY operation
function c27000208.spop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end

-- Send to GY to Special Summon from Deck target
function c27000208.spfilter(c,e,tp)
	return c:IsSetCard(0xf12) and not c:IsCode(id) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function c27000208.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c27000208.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end

-- Send to GY to Special Summon from Deck operation
function c27000208.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c27000208.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if #g>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end

-- Check if it's the opponent's turn

function c27000208.sfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end

-- Select a Spell/Trap card on the field to destroy
function c27000208.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c27000208.sfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c27000208.sfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end

-- Destroy the selected Spell/Trap card
function c27000208.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c27000208.sfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if #g>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
