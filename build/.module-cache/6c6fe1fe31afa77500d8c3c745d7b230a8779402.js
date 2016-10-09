/** @jsx React.DOM */
var TodoList = React.createClass({displayName: "TodoList",
  render: function() {
    var _this = this;
    var createItem = function(item, index) {
      return (
        React.createElement("li", {key:  index }, 
           item.gender, " | ", item.age, 
          React.createElement("span", {onClick:  _this.props.removeItem.bind(null, item['.key']), 
                style: { color: 'red', marginLeft: '10px', cursor: 'pointer'}}, 
            "X"
          )
        )
      );
    };
    return React.createElement("ul", null,  this.props.items.map(createItem) );
  }
});

var TodoApp = React.createClass({displayName: "TodoApp",
  mixins: [ReactFireMixin],

  getInitialState: function() {
    return {
      items: [],
      gender: '',
      age:0
    };
  },

  componentWillMount: function() {
    var firebaseRef = firebase.database().ref('/items');
    this.bindAsArray(firebaseRef, 'items');
  },

  onChange: function(e) {
    this.setState({text: e.target.value});
  },

  render: function() {
    return (
      React.createElement("div", null, 
        React.createElement(TodoList, {items:  this.state.items, removeItem:  this.removeItem})
      )
    );
  }
});

ReactDOM.render(React.createElement(TodoApp, null), document.getElementById('todoApp'));
