/** @jsx React.DOM */
var TodoList = React.createClass({
  render: function() {
    var _this = this;
    var createItem = function(item, index) {
      return (
        <li key={ index }>
          { item.gender } | {item.age}
          <span onClick={ _this.props.removeItem.bind(null, item['.key']) }
                style={{ color: 'red', marginLeft: '10px', cursor: 'pointer' }}>
            X
          </span>
        </li>
      );
    };
    return <ul>{ this.props.items.map(createItem) }</ul>;
  }
});

var TodoApp = React.createClass({
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

  removeItem: function(key) {
    var firebaseRef = firebase.database().ref('/items');
    firebaseRef.child(key).remove();
  },

  render: function() {
    return (
      <div>
        <TodoList items={ this.state.items } removeItem={ this.removeItem } />

      </div>
    );
  }
});

ReactDOM.render(<TodoApp />, document.getElementById('todoApp'));
