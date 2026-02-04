local hexagon = require('../..')
local object = hexagon.Classes.HxObject()
local this : any = object

return function ()
	describe('Class check', function() 
		it('Interface should be a table without metatable', function()
			expect(this).to.be.a('table')
			expect(getmetatable(this)).never.be.a('table')
		end)
		it('Interface should have a class', function()
			expect(this.class).to.be.a('table')
			expect(this.class.__index).to.be.a('table')
			expect(this.class.ClassName).to.be.a('string')
			expect(this.class.Source).to.be.a('ModuleScript')
		end)
		
		if this.new then
			it('Interface should have a constructor function', function() 
				expect(this.new).to.be.a('function')
			end)
			it('Result is a class object', function() 
				local v = this.new({})
				local m = getmetatable(v)
				
				expect(v).to.be.a('table')
				expect(m).to.be.a('table')
				expect(m.__index).to.equal(this.class)
			end)
		end
		
		if this.get then
			it('Interface should have a getter function', function() 
				expect(this.get).to.be.a('function')
			end)
		end	
	end)
end