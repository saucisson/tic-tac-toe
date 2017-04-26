-- Tic-Tac-Toe
-- ===========
--
-- For more information, see
-- [Tic-tac-toe](https://en.wikipedia.org/wiki/Tic-tac-toe).

return function (Layer, tictactoe, ref)

  local meta        = Layer.key.meta
  local refines     = Layer.key.refines
  local collection  = Layer.require "data.collection@ardoises/formalisms:dev"
  local enumeration = Layer.require "data.enumeration@ardoises/formalisms:dev"
  local interaction = Layer.require "interaction@ardoises/formalisms:dev"

  tictactoe [refines] = {
    collection,
  }
  tictactoe [meta] = {
    [collection] = {
      value_container = ref [meta].tokens,
    },
    tokens = {
      [refines] = {
        enumeration,
      },
      [meta] = {
        [enumeration] = {
          symbol_type = "string",
        },
      },
      _ = "_",
      X = "X",
      O = "O",
    }
  }

  for row = 1, 3 do
    for column = 1, 3 do
      local key = tostring (row) .. "-" .. tostring (column)
      tictactoe [key] = tictactoe [meta].tokens._
    end
  end

  tictactoe [meta] [interaction.gui] = function (parameters)
    assert (type (parameters) == "table")
    local Et         = require "etlua"
    local renderer   = {}
    renderer.editor  = assert (parameters.editor)
    renderer.module  = assert (parameters.module)
    renderer.target  = assert (parameters.target)
    renderer.edited  = renderer.editor:require (renderer.module)
    renderer.running = true
    renderer.target.innerHTML = Et.render ([[
      <div class="container-fluid">
        <div class="row">
          <div class="col-sm-12">
            <table class="table" align="center">
              <% for i = 1, 3 do %>
              <tr>
                <% for j = 1, 3 do %>
                <td class="td" id="cell-<%= i %>-<%= j %>"></td>
                <% end %>
              </tr>
              <% end %>
            </table>
          </div>
        </div>
      </div>
    ]])
    function renderer.close ()
      renderer.running = false
      renderer.target.innerHTML = nil
    end
    return renderer
  end

end
