abstract class UseCase<Params, ReturnValue>{
  ReturnValue call(Params params);
}

class UseCaseNoParams {}