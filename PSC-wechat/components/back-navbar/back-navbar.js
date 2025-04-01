Component({
    properties: {
      title: {
        type: String,
        value: '标题',
      },
    },
  
    methods: {
      handleBack() {
        wx.navigateBack();
      },
    },
  });